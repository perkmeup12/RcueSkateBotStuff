%Matthew Perkins
%simulation of skatebot glide phase with given inital conditions.
%Skate modeling script
clc;clear;close all;
load SWliftdragdata.mat
load relativetipmotion12_5.mat

%assumptions
%no friction force from tail during glide phase
%y reference starts at height of mount at rest. all references from
%assume constant angle of attack for now
%initial conditions are known

%skate constant values
gravity=-9.81;                                  %acceleration due to gravity (m/s^2)
dwater=1000;                                    %Density of water (kg/m^3)
motorvoleng=pi*2.875^2/4*5.5;                   %volume of motor housing
vehvoleng=632.88;                               %displacement of the vehicle (in^3)
vehvolmet=vehvoleng*1.6387*10^-5;               %displacement of vehicle(m^3)
buoyforce=-vehvolmet*dwater*gravity;            %buoyant force on vehicle
buoydist=.01189;                                %distance of buoyant force from cg (m)
vehiclemass=10.1687;                            %total mass of vehicle in kg
additionalmass=1.53-.34;                        %additional ballast (kg)
totalmass=vehiclemass+additionalmass;
gravforce=totalmass*gravity;
dragcoeff=1.72;                                 %calculated from SW flow sim
crossarea=.02135;                               %cross sectional area of bottom of vehicle(m^2)
IZZ=.31873;                                     %rotational moment of inertia (Kg*m^2)
mountcgdifx=0.151638;                           %distance between cg and mountlocation (m)
mountcgdify=1.5*2.54/100;                       %vertical distance between cg and mount loc (m)
Cgx=12.28*.0254;                                      %horizontal distance from nose to center of gravity (m)
Cgy=-0.0115;                                          %vertical distance from nose to center of gravity (m)
Cop=7*.0254;                                          %horizontal distance from nose to center of pressure (m)
tailstart=27.5*.0254;                                 %horizontal distance from nose to start of tail piece (m)
taildist=tailstart-Cgx;                               %distance from cg to tail
taillength=.2032;                                           %length of tail in meters
%tailEI=0.0624;                                              %modulus of elasticity times area moment of inertia of tail
tailEI=.036




%dimensions of approximate ellipsoid for added mass force
%calculations
a=.35;              %forward radius (m)
b=.07;              %vertical radius(m)
c=.305;             %side radius (m)
% m22fun= @(intx) (dwater*pi)*(1-intx.^2/c)*a;
% m22=integral(m22fun,-c,c)  %ellipsoid approximation
% %hm22=269.3916
% m11fun=@(intx) (dwater*pi)*(1-intx.^2/c)*b;
% m11=integral(m11fun,-c,c)
%  m66fun= @(intx2) intx2.^2.*(1/8)*(dwater*pi).*(((1-intx2.^2/c)*a).^2-((1-intx2.^2/c)*b).^2);
%  m66=integral(m66fun,-c,c)
% %m66=.21;


%from newman's graph  b/a=.2
m11prime=.5;
m22prime=.9;
m66prime=.7;
m11=m11prime*4/3*pi*dwater*a*b^2;
m22=m22prime*4/3*pi*dwater*a*b^2;
m66=m66prime*4/15*pi*dwater*a*b^2*(a^2+b^2);

%m22=dwater*pi*a^2;       %flat plate approximation
%m22=0
%m66=0;
%% Video constants
colors=hsv(6);
timeperframe=1/60;
startframes=[4,5,5,6,12,2];
glidestartframes=[32,33,38,36,44,33];
glideendframes=[65,69,73,77,85,69];
glidetimes=(glideendframes-glidestartframes)*timeperframe;

%design a filter for video capture data
D = designfilt('lowpassiir','FilterOrder',4, ...
    'PassbandFrequency',10,'PassbandRipple',0.2, ...
    'SampleRate',60);

%% Experimental data
%Galil and IMU Data parse and plot

%define filename time variables
d=700:100:1200;
for I=1:length(d)
    delay=d(I);
    eval(['oldfold=cd([''C:\Users\Matt\Desktop\Skate\results2\Cg12.28\leg 12.5\only2wgts\d'',num2str(delay)])'])
    
    
    %%    Video data
    %change directory
    eval(['oldfold2=cd([''C:\Users\Matt\Desktop\Skate\results2\Cg12.28\leg 12.5\only2wgts\d'',num2str(delay)])'])
    eval(['load(''d',num2str(delay),'videopositions'',''d',num2str(delay),'positions'');'])
    strctname=['d',num2str(delay),'positions'];
    
    %convert to inches
    eval(['xcalibration=(',strctname,'.tail.x(1)-',strctname,'.seconddot.x(1))/22.6378;'])          %ppi
    eval(['ycalibration=',strctname,'.ycalibration;'])
    eval(['seconddotloc=[',strctname,'.seconddot.x/xcalibration,',strctname,'.seconddot.y/ycalibration];'])
    eval(['tailloc=[',strctname,'.tail.x/',strctname,'.xcalibration,',strctname,'.tail.y/',strctname,'.ycalibration];'])
    
    %%%% adjust data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %set first dot as zero and negate x direction
    seconddotloc(:,1)=-(seconddotloc(:,1)-tailloc(1,1));
    seconddotloc(:,2)=(seconddotloc(:,2)-tailloc(1,2));
    tailloc(:,1)=-(tailloc(:,1)-tailloc(1,1));
    tailloc(:,2)=(tailloc(:,2)-tailloc(1,2));
    
    cd(oldfold2)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%
    
    % open file and parse data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    initialwait=2.5;                      %initial wait before program starts (3sec)
    trimlength=2;                       %video only lasts 4 seconds, we'll take 6 secs of data to be safe
    L1=dir('*imudata.txt');
    L2=dir('*galildata.txt');
    %create file names
    % decimal=sprintf('%0.3f',str2num(fSx));
    % imufilename=[sprintf('%02d',fH),',',sprintf('%02d',fM),',',sprintf('%02d',floor(fS)),decimal(2:end),'imudata.txt'];
    % galilfilename=[sprintf('%02d',fH),',',sprintf('%02d',fM),',',sprintf('%02d',floor(fS)),decimal(2:end),'galildata.txt'];
    imufilename=L1.name;
    galilfilename=L2.name;
    
    %open files and make FID
    imuFID=fopen(imufilename);
    galilFID=fopen(galilfilename);
    
    %scan file data
    imudata=textscan(imuFID,'%f,%f,%f,%6c,%f,%f,%f,%f,%f,%f,%f,%f,%f*%s','headerlines',2);
    galildata=textscan(galilFID,'%1c%f,%f,%f,%f %f','headerlines',1);
    
    %assign IMU data to variables
    imuH=imudata{:,1};                            %hour from imu file
    imuM=imudata{:,2};                            %minute from imu file
    imuS=imudata{:,3};                            %second from imu file
    imulabel=imudata{:,4};                        %label string
    SensorYaw=imudata{:,5};                       %calculated attitude heading angle in degrees
    SensorPitch=imudata{:,6};                     %calculated attitude pitch angle in degrees
    SensorRoll=imudata{:,7};                      %calculate attitude roll angle in degrees
    SensorBodyAccelX=imudata{:,8};                %Linear Accel estimate in body x axis (no gravity) m/s^2
    SensorBodyAccelY=imudata{:,9};                %Linear Accel estimate in body y axis (no gravity) m/s^2
    SensorBodyAccelZ=imudata{:,10};               %Linear Accel estimate in body z axis (no gravity) m/s^2
    SensorGyrox=imudata{:,11};                    %Compensated angular rate in the body X-axis rad/s
    SensorGyroy=imudata{:,12};                    %Compensated angular rate in the body Y-axis rad/s
    SensorGyroz=imudata{:,13};                    %Compensated angular rate in the body Z-axis rad/s
    
    %assign Galil data to variables
    galilH=galildata{:,2};                            %hour from galil file
    galilM=galildata{:,3};                            %minute from galil file
    galilS=galildata{:,4};                            %second from galil file
    galilMotorVelocity=galildata{:,5};                %velocity of motor cnts/s
    galilEncoderPosition=galildata{:,6};              %position of motor cnts
    
    
    %clear data to minimize memory usage
    clearvars imudata galildata
    
    %maketimevectors
    imutstart=[imuH(1),imuM(1),imuS(1)];
    imutimevec=(imuH-imutstart(1))*3600+(imuM-imutstart(2))*60+imuS-imutstart(3);
    
    galiltstart=[galilH(1),galilM(1),galilS(1)];
    galiltimevec=(galilH-galiltstart(1))*3600+(galilM-galiltstart(2))*60+galilS-galiltstart(3);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% trim data %%%%%%%%%%%%%%%%%%%%%
    
    %imu
    imuInd=find(imutimevec>=initialwait & imutimevec<initialwait+trimlength);
    imutimevec=imutimevec(imuInd);
    SensorYaw=SensorYaw(imuInd);
    SensorPitch=SensorPitch(imuInd);
    SensorRoll=SensorRoll(imuInd);
    SensorBodyAccelX=SensorBodyAccelX(imuInd);
    SensorBodyAccelY=SensorBodyAccelY(imuInd);
    SensorBodyAccelZ=SensorBodyAccelZ(imuInd);
    SensorGyrox=SensorGyrox(imuInd);
    SensorGyroy=SensorGyroy(imuInd);
    SensorGyroz=SensorGyroz(imuInd);
    
    %redefine variables
    VehR=SensorGyrox;
    Vehpitch=SensorRoll;
    VehAx=SensorBodyAccelY;
    VehAy=-SensorBodyAccelZ;
    
    %galil
    galilInd=find(galiltimevec>initialwait & galiltimevec<initialwait+trimlength);
    galiltimevec=galiltimevec(galilInd);
    galilEncoderPosition=galilEncoderPosition(galilInd);
    galilMotorVelocity=galilMotorVelocity(galilInd);
    
    %encoder start time
    encind=find(galilEncoderPosition<0);
    enctime=galiltimevec(encind(1));
    
    %determine imutimevector needed to compare data
    glidestart=enctime+(glidestartframes(I)-startframes(I))*timeperframe;
    glideduration=glidetimes(I);    %.567;
    indexcompare=find(imutimevec>=enctime & imutimevec<=glidestart+glideduration);
    
    %time vector for comparison plots
    comparetimevec=imutimevec(indexcompare)-imutimevec(indexcompare(1));
    
    %initial condition approximations
    %initial pitch conditions from IMU data
    indexpitch=find(imutimevec>=glidestart & imutimevec<glidestart+glideduration);
    %     Vehpitchinit=Vehpitch(indexpitch(1));
    %     Vehpitchrateinit=VehR(indexpitch(1));
    index=find(imutimevec>enctime+.2&imutimevec<enctime+.4);
    dif=diff(imutimevec);
    %     VehVxinit=sum(SensorBodyAccelY(index).*dif(index));
    %     VehVyinit=sum(SensorBodyAccelZ(index).*dif(index));
    
    
    cd(oldfold)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Analyze some of the data to make some model comparisons
    
    %VIDEO DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %filter data
    seconddotloc(:,1)=filtfilt(D,seconddotloc(:,1));
    seconddotloc(:,2)=filtfilt(D,seconddotloc(:,2));
    tailloc(:,1)=filtfilt(D,tailloc(:,1));
    tailloc(:,2)=filtfilt(D,tailloc(:,2));
    
    %calculate pitch
    videopitchangle=(atand((seconddotloc(:,2)-tailloc(:,2))./(seconddotloc(:,1)-tailloc(:,1))));
    videopitchrates=diff(videopitchangle)/timeperframe;
    
    vidpitchind=find(comparetimevec>.25 & comparetimevec<.35);
    pitchoffset=0;%mean(Vehpitch(indexcompare(vidpitchind)))-mean(videopitchangle(startframes(I):startframes(I)+10));
    videopitchangle=videopitchangle+pitchoffset;
    
    %calculate cg location, column 1 is x location, column 2 is y location
    %cg located 12.28-4.92 inches behind seconddot
    videocgloc(:,1)=seconddotloc(:,1)-7.36*cosd(videopitchangle);        %x (in)
    videocgloc(:,2)=seconddotloc(:,2)-7.36*sind(videopitchangle);        %y (in)
    videocgloc=videocgloc*.0254;                                         %(m) Converted to meters
    cgoffsetangle=videopitchangle(1);
    cgyoffset=sind(-cgoffsetangle)*mountcgdifx+cosd(-cgoffsetangle)*mountcgdify+.1; %vertical distance above ground of cg at rest
    videocgloc(:,2)=-videocgloc(:,2)+cgyoffset;
    
    %calculate velocities
    videoVx=diff(videocgloc(:,1))/timeperframe;
    videoVy=diff(videocgloc(:,2))/timeperframe;
    
    %calculate velocities
    videoAx=diff(videoVx)/timeperframe;
    videoAy=diff(videoVy)/timeperframe;
    
    %find corresponding time vector
    videotimevec=(0:(glideendframes(I)-startframes(I)))*timeperframe;
    
    %inital conditions for simulation
    Vehpitchinit=videopitchangle(glidestartframes(I));            %deg
    Vehpitchrateinit=videopitchrates(glidestartframes(I))*pi/180; %rad/s
    VehVxinit=videoVx(glidestartframes(I));                         %m/s
    VehVyinit=videoVy(glidestartframes(I));                         %m/s
    
    %     %estimates by integration of instantaneous velocities and position
    %     VehVx=[];
    %     VehVy=[];
    %     Vehx=[];
    %     Vehy=[];
    %     for iii=1:length(indexcompare)
    %         VehVx(iii)=VehVxinit+sum(SensorBodyAccelY(indexcompare(1:iii)).*dif(indexcompare(1:iii)));
    %         VehVy(iii)=VehVyinit+sum((SensorBodyAccelZ(indexcompare(1:iii))).*dif(indexcompare(1:iii)));
    %     end
    %     for iii=1:length(indexcompare)
    %         Vehx(iii)=sum(VehVx(1:iii).*dif(indexcompare(1:iii))')+xsave(1);
    %         Vehy(iii)=sum(VehVy(1:iii).*dif(indexcompare(1:iii))')+ysave(1);
    %     end
    %
    %     %experimental orientation
    %     for iii=1:length(indexcompare)
    %         exmidx(iii)=Vehx(iii)-abs(cosd(Vehpitch(iii))*mountcgdifx);
    %         exmidy(iii)=Vehy(iii)+abs(sind(Vehpitch(iii))*mountcgdifx)*sign(Vehpitch(iii));
    %         exmountx(iii)=exmidx(iii)+abs(sind(Vehpitch(iii))*mountcgdify)*-sign(Vehpitch(iii));
    %         exmounty(iii)=exmidy(iii)-abs(cosd(Vehpitch(iii))*mountcgdify);
    %     end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% simulation
    dt=.001;                            %time step
    % time=0:dt:1.5;                        %time vector (s)
    
    %initial condition
    i=0;                                                                    %iteration variable
    pitchangle=Vehpitchinit;                                                %Vehicle pitch angle (deg)
    r=Vehpitchrateinit;
    mountx=0;                                                               %horizontal location of leg mount(m)
    mounty=.04;                                                             %vertical location of leg mount (m)
    midx=mountx+sind(-pitchangle)*mountcgdify*sign(-pitchangle);              %point directly above leg mount parallel with cg
    midy=mounty+abs(cosd(-pitchangle)*mountcgdify);                          %
    %     x=midx+(cosd(pitchangle)*mountcgdifx);                                  %cg horizontal location
    %     y=midy+(sind(pitchangle)*mountcgdifx*-sign(pitchangle));                %cg vertical location
    x=videocgloc(glidestartframes(I),1);
    y=videocgloc(glidestartframes(I),2);
    Vx=videoVx(glidestartframes(I));                                         %Horizontal vehicle velocity (m/s) inertial frame
    Vy=videoVy(glidestartframes(I));                                        %Vertical vehicle velocity (m/s) inertial frame
    Ax=videoAx(glidestartframes(I));                                         %Horizontal vehicle accel (m/s^2) inertial frame
    Ay=videoAy(glidestartframes(I));                                         %Vertical vehicle accel (m/s^2) inertial frame
    phase=0;                                                                %indication of glide or launch phase
    u=cosd(-pitchangle)*Vx-sind(-pitchangle)*Vy;                              %vehicle forward velocity(m/s) body frame
    v=sind(-pitchangle)*Vx+cosd(-pitchangle)*Vy;                              %vehicle upwards velocity (m/s) body frame                                                                 %vehicle pitch rate (deg/s)
    udot=cosd(-pitchangle)*Vx-sind(-pitchangle)*Vy;                          %vehicle forward acceleration (m/s^2) body frame
    vdot=sind(-pitchangle)*Vx+cosd(-pitchangle);                             %vehicle upwards acceleration (m/s^2) body frame
    rdot=0;                                                                 %vehicle pitch acceleration
    
    %initialize save variables, will save variables from each iteration
    %into a vector
    xsave=[x];
    ysave=[y];
    Vxsave=[Vx];
    Vysave=[Vy];
    Axsave=[Ax];
    Aysave=[Ay];
    phasesave=[phase];
    liftsave=[0];
    usave=[u];
    vsave=[v];
    udotsave=[udot];
    vdotsave=[vdot];
    rsave=[r];
    rdotsave=[rdot];
    mountxsave=mountx;
    mountysave=mounty;
    pitchanglesave=pitchangle;
    midxsave=midx;
    midysave=midy;
    liftanglesave=atand(v/u);
    tailforcesave=[0];
    xtipsave=[x-cosd(pitchangle)*taildist-sind(45+pitchangle)*taillength-cosd(45+pitchangle)*0];
    deformdistsave=[0];
    %initialize iteration variables
    running=1;                                                              %used to stop code
    t=(glidestartframes(I)-startframes(I))*timeperframe; %imutimevec(indexpitch(1))-imutimevec(indexcompare(1));                                            %current time variable
    time=t;                                                                 %variable to save time into a vector
    while running==1;
        i=i+1;                                                              %increment counter
        t=t+dt;                                                             %increment time variable
        time=[time,t];                                                      %add current time to time save vector
        
        if (time(end)-time(1))<=glidetimes(I)%y>0 &&mounty>0                          %simulate vehicle glide phase
            % Skate is gliding%%%%%%%%%%%%%%%%%%
            
            %update variables
            x=x+Vx*dt;
            y=y+Vy*dt;
            midx=x-abs(cosd(-pitchangle)*mountcgdifx);
            midy=y+abs(sind(-pitchangle)*mountcgdifx)*sign(pitchangle);
            mountx=midx+abs(sind(-pitchangle)*mountcgdify)*-sign(pitchangle);
            mounty=midy-abs(cosd(-pitchangle)*mountcgdify);
            pitchangle=pitchangle+r*dt*180/pi;
            u=u+udot*dt;
            v=v+vdot*dt;
            r=r+rdot*dt;
            Vx=cosd(-pitchangle)*u+sind(-pitchangle)*v;
            Vy=-sind(-pitchangle)*u+cosd(-pitchangle)*v;
            Ax=cosd(-pitchangle)*udot+sind(-pitchangle)*vdot;
            Ay=-sind(-pitchangle)*udot+cosd(-pitchangle)*vdot;
            
            % FORCES %%%%%%%%%%%%%%%%%%%%%%%%55
            %lift
            liftangle=-atand(v/u);
            V1=.7112*cosd(liftangle); %horizontal velocity of flow test (m/s)
            
            Fl1=interp1(SWdatastruct.AoA.data,SWdatastruct.lift.data,liftangle,'linear','extrap'); %lift force at one BL/s at current AoA
            Fd1=interp1(SWdatastruct.AoA.data,SWdatastruct.drag.data,liftangle,'linear','extrap'); %drag force at one BL/s at current AoA
            liftforce=u^2*Fl1/V1^2;  %lift force at current speed
            
            
            %drag
            vertFd=.5*dwater*dragcoeff*crossarea*-v;                  %vertical drag force.
            %vertFd=0;
            horizFd=-u^2*Fd1/V1^2;
            
            %munk moment
            munkmoment=-u*v*(m22-m11);
            
            %tailforce
            tailmountheight=y+sind(pitchangle)*taildist;                %height of tail mount above ground
            tailmountx=x-cosd(pitchangle)*taildist;                     %horizontal location of tailmount
            rigidtheta=45+pitchangle;                                   %if tail was rigid the angle difference from vertical
            rigidheight=tailmountheight-cosd(rigidtheta)*taillength;    %if tail was rigid the tip would reach this height
            deformtheta=(90-rigidtheta)*pi/180;                         %total angle of deflection in radians
            
            if rigidheight<0
                tailforce=deformtheta*2*tailEI/taillength^2;
                deformdist=tailforce*taillength^3/(3*tailEI);
            else
                deformdist=0;
                tailforce=0;
            end
            xtip=tailmountx-sind(rigidtheta)*taillength-cosd(rigidtheta)*deformdist;
            
            %%%%%%%%%%%%calculate new accelerations%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %         Ax=(horizFd/(totalmass));                              %horizontal acceleration
            %         Ay=(buoyforce+gravforce+vertFd+liftforce)/(totalmass+m22); %vertical acceleration
            
            udot=(horizFd+totalmass*-r*v)/totalmass;
            vdot=(buoyforce+gravforce+vertFd+liftforce+tailforce+(totalmass+m22)*r*u)/(totalmass+m22);
            rdot=-(liftforce*(Cgx-Cop)-tailforce*(x-xtip)+buoyforce*buoydist*cosd(-pitchangle)+munkmoment)/(IZZ+m66);
            phase=2;
        else
            %skate has hit the ground, stopping the vehicle
            phase=0;
            running=0;
        end
        
        %save variables
        xsave=[xsave,x];
        ysave=[ysave,y];
        Vxsave=[Vxsave,Vx];
        Vysave=[Vysave,Vy];
        Axsave=[Axsave,Ax];
        Aysave=[Aysave,Ay];
        liftsave=[liftsave,liftforce];
        phasesave=[phasesave,phase];
        usave=[usave,u];
        vsave=[vsave,v];
        udotsave=[udotsave,udot];
        vdotsave=[vdotsave,vdot];
        rsave=[rsave,r];
        rdotsave=[rdotsave,rdot];
        mountxsave=[mountxsave,mountx];
        mountysave=[mountysave,mounty];
        pitchanglesave=[pitchanglesave,pitchangle];
        midxsave=[midxsave,midx];
        midysave=[midysave,midy];
        liftanglesave=[liftanglesave,liftangle];
        tailforcesave=[tailforcesave,tailforce];
        xtipsave=[xtipsave,xtip];
        deformdistsave=[deformdistsave,deformdist];
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%
    %Dive Angles
    figure
    plot(time,pitchanglesave,'b',comparetimevec,Vehpitch(indexcompare),'r',videotimevec,videopitchangle(startframes(I):glideendframes(I)),'g')
    xlabel('time (s)')
    ylabel('Pitch angle (deg)')
    title(['Delay ',num2str(delay),' PitchAngles'])
    legend('Modeled','Imu Data','Video Capture','Location','Best')
    
    %     %encoder position
    %     figure
    %     plot(galiltimevec,galilEncoderPosition)
    %     title(['Delay ',num2str(delay),' Encoder Positions'])
    %     xlabel('time (s)')
    %     ylabel('cnts')
    
    % %Pitch rates
    % figure
    % plot(time,rsave,comparetimevec,VehR(indexcompare))
    % title(['Delay ',num2str(delay),' Pitch Rates'])
    % xlabel('time (s)')
    % ylabel('rad/s')
    % legend('Modeled','Experimental')
    
    % %Velocities
    % figure
    % plot(time,Vxsave,'b',comparetimevec,VehVx,'b--',time,Vysave,'r',comparetimevec,VehVy,'r--');
    % title(['Delay ',num2str(delay),' Vehicle Inertial Velocities'])
    % xlabel('time(s)')
    % ylabel('Velocity (m/s)')
    % legend('Modeled Vx','Experimental Vx','Modeled Vy','Experimental Vy')
    %
    %Position
    figure
    plot(xsave,ysave,'g',videocgloc(startframes(I):glideendframes(I),1),videocgloc(startframes(I):glideendframes(I),2),'g--');
    title(['Delay ',num2str(delay),' Vehicle Positions'])
    xlabel('X (m)')
    ylabel('Y (m)')
    legend('Modeled','Video Capture','Location','Best')
    hold on
    for ii=[1,200,400,length(xsave)]%1:round(length(xsave)/6):length(xsave)
        % read NACA file
        %first half is top second is bottom
        [NX,NY]=textread('naca4412coordinates.txt','%f %f');
        
        % Scaling the figure
        bodylength=.7;          %length of foil (m)
        SF=(bodylength/(max(NX)-min(NX)));
        NX=-NX*SF+Cgx;
        NY=NY*SF+Cgy;
        
        % rotate foil 5 degrees
        NR= [cosd(pitchanglesave(ii)),-sind(pitchanglesave(ii)); sind(pitchanglesave(ii)),cosd(pitchanglesave(ii))];
        Ncoord=[NX,NY];
        Ncoordrot=Ncoord*NR;
        
        %new x and y coordinates for foil at 5 degree angle of attack
        Nx=Ncoordrot(:,1)+xsave(ii);
        Ny=Ncoordrot(:,2)+ysave(ii);
        
        plot(Nx,Ny,'b',xsave(ii),ysave(ii),'.r')
        axis equal
        hold on
    end
    for ii=[startframes(I):20:glideendframes(I)]
        % read NACA file
        %first half is top second is bottom
        [VnacX,VnacY]=textread('naca4412coordinates.txt','%f %f');
        
        % Scaling the figure
        bodylength=.7;          %length of foil (m)
        SF=(bodylength/(max(VnacX)-min(VnacX)));
        VnacX=-VnacX*SF+Cgx;
        VnacY=VnacY*SF+Cgy;
        
        % rotate foil 5 degrees
        VR= [cosd(videopitchangle(ii)),-sind(videopitchangle(ii)); sind(videopitchangle(ii)),cosd(videopitchangle(ii))];
        Vcoord=[VnacX,VnacY];
        Vcoordrot=Vcoord*VR;
        
        %new x and y coordinates for foil at 5 degree angle of attack
        Vnacx=Vcoordrot(:,1)+videocgloc(ii,1);
        Vnacy=Vcoordrot(:,2)+videocgloc(ii,2);
        %plot(Vnacx,Vnacy,'r',videocgloc(ii,1),videocgloc(ii,2),'.b')
        hold on
    end
    legend('Modeled','Video Capture','Location','Best')
    
    %
    % %Vertical Height above ground
    % figure
    % plot(time,ysave*100,comparetimevec,Vehy*100)
    % title(['Delay ',num2str(delay),' Vehicle Height above Ground'])
    % xlabel('time (s)')
    % ylabel('Height (cm)')
    % legend('Modeled','Experimental')
    
    % %vehicle orientation
    
    %         figure
    %         plot(xsave,ysave,'g')
    %         hold on
    %         for ii=[1,200,400,length(xsave)]%1:round(length(xsave)/6):length(xsave)
    %          % read NACA file
    %             %first half is top second is bottom
    %             [NX,NY]=textread('naca4412coordinates.txt','%f %f');
    %
    %             % Scaling the figure
    %             bodylength=.7;          %length of foil (m)
    %             SF=(bodylength/(max(NX)-min(NX)));
    %             NX=-NX*SF+Cgx;
    %             NY=NY*SF+Cgy;
    %
    %             % rotate foil 5 degrees
    %             degrot=pitchanglesave(ii);
    %             NR= [cosd(degrot),-sind(degrot); sind(degrot),cosd(degrot)];
    %             coord=[NX,NY];
    %             coordrot=coord*NR;
    %
    %             %new x and y coordinates for foil at 5 degree angle of attack
    %             Nx=coordrot(:,1)+xsave(ii);
    %             Ny=coordrot(:,2)+ysave(ii);
    %
    %             plot(Nx,Ny,'b',xsave(ii),ysave(ii),'.r')
    %             xlabel('x (m)')
    %             ylabel('y (m)')
    %             title(['Delay ',num2str(delay), ' Vehicle Orientation'])
    %             axis equal
    %             hold on
    %         end
    % for ii=1:length(Vehx)
    %     orientationx1=[Vehx(ii);exmidx(ii)];
    %     orientationy1=[Vehy(ii);exmidy(ii)];
    %     orientationx2=[exmidx(ii);exmountx(ii)];
    %     orientationy2=[exmidy(ii);exmounty(ii)];
    %     plot(orientationx1,orientationy1,'g',orientationx2,orientationy2,'k');
    % end
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
%calculate best delay based on initial conditions
kicktime=.25;  %time from start of motion to impact (s)
bestkickdifx=mountcgdifx;
bestkickdify=mountcgdify+.02;    %2cm below mount
bestkickx=midx+abs(sind(pitchangle)*bestkickdify)*-sign(pitchangle);
bestkicky=midy-abs(cosd(pitchangle)*bestkickdify);

figure
plot(tailforcesave)



