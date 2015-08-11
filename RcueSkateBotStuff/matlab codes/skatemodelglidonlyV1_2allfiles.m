%Matthew Perkins
%simulation of skatebot glide phase with given inital conditions.

%Skate modeling script
clc;clear;
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
Cgx=12.28;                                      %distance from nose to center of gravity
Cop=7;                                          %distance from nose to center of pressure



AoA=1;  %angle of attack
V1=.7112*cosd(AoA); %horizontal velocity of flow test (m/s)

%dimensions of approximate ellipsoid for added mass force
%calculations
a=.35;              %forward radius (m)
b=.07;              %vertical radius(m)
c=.305;             %side radius (m)
m22fun= @(intx) (dwater*pi)*(1-intx.^2/c)*a;
m22=integral(m22fun,-c,c)  %ellipsoid approximation
m11fun=@(intx) (dwater*pi)*(1-intx.^2/c)*b;
m11=integral(m11fun,-c,c)
m66fun= @(intx2) intx2.^2.*(1/8)*(dwater*pi).*(((1-intx2.^2/c)*a).^2-((1-intx2.^2/c)*b).^2);
m66=integral(m66fun,-c,c)
%m66=.21;

%m22=dwater*pi*a^2;       %flat plate approximation
%m22=0
%m66=0;
%% Video constants
colors=hsv(8);
timeperframe=1/30;
glidestartframes=[19,19,17,19,17,17,17,17];
glideendframes=[33,33,32,36,37,35,35,36];
glidetimes=(glideendframes-glidestartframes)*timeperframe;

%% Experimental data
%Matthew Perkins
%Galil and IMU Data parse and plot


%define filename time variables
d=700:100:1200;
for I=1:length(d)
    delay=d(I);
    eval(['oldfold=cd([''C:\Users\Matt\Desktop\Skate\results2\Cg12.28\leg 12.5\only2wgts\d'',num2str(delay)])'])
    initialwait=2.5;                      %initial wait before program starts (3sec)
    trimlength=6;                       %video only lasts 4 seconds, we'll take 6 secs of data to be safe
    L1=dir('*imudata.txt');
    L2=dir('*galildata.txt');
    
    % open file and parse data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
    imuInd=find(imutimevec>initialwait & imutimevec<initialwait+trimlength);
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
    
    %determine imutimevector needed to compare data
    accelstart=3.2;
    glidestart=3.4;
    glideduration=glidetimes(I);    %.567;
    indexcompare=find(imutimevec>=glidestart&imutimevec<=glidestart+glideduration);
    
    %time vector for comparison plots
    comparetimevec=imutimevec(indexcompare)-imutimevec(indexcompare(1));
    
    %galil
    galilInd=find(galiltimevec>initialwait & galiltimevec<initialwait+trimlength);
    galiltimevec=galiltimevec(galilInd);
    galilEncoderPosition=galilEncoderPosition(galilInd);
    galilMotorVelocity=galilMotorVelocity(galilInd);
    
    %initial condition approximations
    index=find(imutimevec>3.2&imutimevec<3.4);
    dif=diff(imutimevec);
    VehVxinit=sum(SensorBodyAccelY(index).*dif(index));
    VehVyinit=sum(SensorBodyAccelZ(index).*dif(index));
    
    VehRinit=SensorGyrox(indexcompare(1));
    Vehpitchinit=SensorRoll(indexcompare(1));
    
    VehAxinit=SensorBodyAccelY(index(end));
    VehAyinit=-SensorBodyAccelZ(index(end));
    
    %final conditions
    indexfin=find(imutimevec>3.4&imutimevec<3.4+.567);
    VehVxfin=sum(SensorBodyAccelY(indexfin).*dif(indexfin));
    VehVyfin=sum(SensorBodyAccelZ(indexfin).*dif(indexfin));
    VehRfin=SensorGyrox(indexfin(end));
    Vehpitchfin=SensorRoll(indexfin(end)+1);
    VehAxfin=SensorBodyAccelY(indexfin(end));
    VehAyfin=-SensorBodyAccelZ(indexfin(end));
    
    cd(oldfold)
    %% simulation
    dt=.001;                            %time step
    % time=0:dt:1.5;                        %time vector (s)
    
    %initial conditions
    pitchangle=Vehpitchinit;  %deg
    i=0;
    mountx=0;
    mounty=.04;
    midy=mounty+abs(cosd(pitchangle)*mountcgdify);
    midx=mountx+sind(pitchangle)*mountcgdify*sign(pitchangle);
    x=midx+(cosd(pitchangle)*mountcgdifx);
    y=midy+(sind(pitchangle)*mountcgdifx*-sign(pitchangle));
    Vx=VehVxinit;
    Vy=VehVyinit;
    Ax=0;
    Ay=0;
    phase=0;
    u=abs(cosd(pitchangle)*Vx)+abs(sind(pitchangle)*Vy)*-sign(pitchangle);
    v=sign(pitchangle)*abs(sind(pitchangle)*Vx)+abs(cosd(pitchangle))*Vy;
    r=.35;
    udot=0;
    vdot=0;
    rdot=0;
    
    %initialize save variables
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
    
    running=1;
    t=0;
    time=[t];
    while running==1;
        i=i+1;
        t=t+dt;
        time=[time,t];
        
        if time(end)<=glidetimes(I)%y>0 &&mounty>0
            % Skate is gliding%%%%%%%%%%%%%%%%%%
            
            %update variables
            x=x+Vx*dt;
            y=y+Vy*dt;
            midx=x-abs(cosd(pitchangle)*mountcgdifx);
            midy=y+abs(sind(pitchangle)*mountcgdifx)*sign(pitchangle);
            mountx=midx+abs(sind(pitchangle)*mountcgdify)*-sign(pitchangle);
            mounty=midy-abs(cosd(pitchangle)*mountcgdify);
            pitchangle=pitchangle+r*dt*180/pi;
            u=u+udot*dt;
            v=v+vdot*dt;
            r=r+rdot*dt;
            Vx=abs(cosd(pitchangle))*u+abs(sind(pitchangle))*v*sign(pitchangle);
            Vy=abs(sind(pitchangle))*-sign(pitchangle)*u+abs(cosd(pitchangle))*v;
            
            % forces
            %lift
            Fl1=interp1(SWdatastruct.AoA.data,SWdatastruct.lift.data,pitchangle,'linear','extrap'); %lift force at one BL/s at current AoA
            if Fl1<0
                Fl1=0;
            end
            Fd1=interp1(SWdatastruct.AoA.data,SWdatastruct.drag.data,pitchangle,'linear','extrap'); %drag force at one BL/s at current AoA
            liftforce= u^2*Fl1/V1^2;  %lift force at current speed
            
            %drag
            vertFd=.5*dwater*dragcoeff*crossarea*-v;                  %vertical drag force.
            %vertFd=0;
            horizFd=-u^2*Fd1/V1^2;
            
            %munkmoment
            munkmoment=-u*v*(m22-m11);
            
            %%%%%%%%%%%%calculate new accelerations%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %         Ax=(horizFd/(totalmass));                              %horizontal acceleration
            %         Ay=(buoyforce+gravforce+vertFd+liftforce)/(totalmass+m22); %vertical acceleration
            
            udot=(horizFd+totalmass*r*v)/totalmass;
            vdot=(buoyforce+gravforce+vertFd+liftforce+(totalmass+m22)*-r*u)/(totalmass+m22);
            rdot=-(liftforce*(Cgx-Cop)+buoyforce*buoydist*abs(cosd(pitchangle)))/(IZZ+m66);
            
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
    end
    
    %% Compare Plots
    
    %estimates by integration of instantaneous velocities and position
    VehVx=[];
    VehVy=[];
    Vehx=[];
    Vehy=[];
    for iii=1:length(indexcompare)
        VehVx(iii)=VehVxinit+sum(SensorBodyAccelY(indexcompare(1:iii)).*dif(indexcompare(1:iii)));
        VehVy(iii)=VehVyinit+sum((SensorBodyAccelZ(indexcompare(1:iii))).*dif(indexcompare(1:iii)));
    end
    for iii=1:length(indexcompare)
        Vehx(iii)=sum(VehVx(1:iii).*dif(indexcompare(1:iii))')+xsave(1);
        Vehy(iii)=sum(VehVy(1:iii).*dif(indexcompare(1:iii))')+ysave(1);
    end
    
    %experimental orientation
    for iii=1:length(indexcompare)
        exmidx(iii)=Vehx(iii)-abs(cosd(Vehpitch(iii))*mountcgdifx);
        exmidy(iii)=Vehy(iii)+abs(sind(Vehpitch(iii))*mountcgdifx)*sign(Vehpitch(iii));
        exmountx(iii)=exmidx(iii)+abs(sind(Vehpitch(iii))*mountcgdify)*-sign(Vehpitch(iii));
        exmounty(iii)=exmidy(iii)-abs(cosd(Vehpitch(iii))*mountcgdify);
    end
    %%    Video data
    %change directory
    eval(['oldfold2=cd([''C:\Users\Matt\Desktop\Skate\results2\Cg12.28\leg 12.5\only2wgts\d'',num2str(delay)])'])
    eval(['load(''d',num2str(delay),'videopositions'',''d',num2str(delay),'positions'');'])
    strctname=['d',num2str(delay),'positions'];
    
    %convert to inches
    eval(['seconddotloc=[',strctname,'.seconddot.x/',strctname,'.xcalibration,',strctname,'.seconddot.y/',strctname,'.ycalibration];'])
    eval(['tailloc=[',strctname,'.tail.x/',strctname,'.xcalibration,',strctname,'.tail.y/',strctname,'.ycalibration];'])
    
    % for ii=1:length(8dotloc(:,1))
    %     orientationx1=[seconddotloc(:,1)';tailloc(:,1)'];
    %     orientationy1=[seconddotloc(:,2)';tailloc(:,2)'];
    %     plot(orientationx1,orientationy1,'r');
    %     title('Vehicle Orientation')
    %     axis equal
    %     hold on
    %     set(gca,'Ydir','reverse')
    % end
    
    %%%% adjust data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %set first dot as zero and negate x direction
    seconddotloc(:,1)=-(seconddotloc(:,1)-tailloc(1,1));
    seconddotloc(:,2)=(seconddotloc(:,2)-tailloc(1,2));
    tailloc(:,1)=-(tailloc(:,1)-tailloc(1,1));
    tailloc(:,2)=(tailloc(:,2)-tailloc(1,2));
    
%     %filter data
%     seconddotloc(:,1)=filtfilt(D,seconddotloc(:,1));
%     seconddotloc(:,2)=filtfilt(D,seconddotloc(:,2));
%     tailloc(:,1)=filtfilt(D,tailloc(:,1));
%     tailloc(:,2)=filtfilt(D,tailloc(:,2));
    
    %calculate pitch
    pitchoffset=0;
    videopitchangle=-(atand((seconddotloc(:,2)-tailloc(:,2))./(seconddotloc(:,1)-tailloc(:,1)))+pitchoffset);
    videopitchrates=diff(pitchangle)/timeperframe;
    
    %calculate cg location
    %cg located 12.28-4.92 inches behind seconddot
    videocgloc(:,1)=seconddotloc(:,1)-7.36*cosd(pitchangle);
    videocgloc(:,2)=seconddotloc(:,2)-7.36*sind(pitchangle);
    
    %find corresponding time vector
    videotimevec=(0:(glideendframes(I)-glidestartframes(I)))*timeperframe;
    
    cd(oldfold2)
    
    %%
    %Dive Angles
    figure
    plot(time,pitchanglesave,'b',comparetimevec,Vehpitch(indexcompare),'r',videotimevec,videopitchangle(glidestartframes(I):glideendframes(I)),'g')
    xlabel('time (s)')
    ylabel('Pitch angle (deg)')
    title(['Delay ',num2str(delay),' PitchAngles'])
    legend('Modeled','Experimental','Video Capture')
    
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
    % %Position
    % figure
    % plot(xsave,ysave,'b',Vehx,Vehy,'b--');
    % title(['Delay ',num2str(delay),' Vehicle Positions'])
    % xlabel('X (m)')
    % ylabel('Y (m)')
    % legend('Modeled','Experimental')
    %
    % %Vertical Height above ground
    % figure
    % plot(time,ysave*100,comparetimevec,Vehy*100)
    % title(['Delay ',num2str(delay),' Vehicle Height above Ground'])
    % xlabel('time (s)')
    % ylabel('Height (cm)')
    % legend('Modeled','Experimental')
    
    % %vehicle orientation
    % figure
    % for ii=1:10:length(xsave)
    %     orientationx1=[xsave(ii);midxsave(ii)];
    %     orientationy1=[ysave(ii);midysave(ii)];
    %     orientationx2=[midxsave(ii);mountxsave(ii)];
    %     orientationy2=[midysave(ii);mountysave(ii)];
    %     plot(orientationx1,orientationy1,orientationx2,orientationy2,'r');
    %     xlabel('x (m)')
    %     ylabel('y (m)')
    %     title(['Delay ',num2str(delay), ' Vehicle Orientation'])
    %     axis equal
    %     hold on
    % end
    % for ii=1:length(Vehx)
    %     orientationx1=[Vehx(ii);exmidx(ii)];
    %     orientationy1=[Vehy(ii);exmidy(ii)];
    %     orientationx2=[exmidx(ii);exmountx(ii)];
    %     orientationy2=[exmidy(ii);exmounty(ii)];
    %     plot(orientationx1,orientationy1,'g',orientationx2,orientationy2,'k');
    % end
    
    
end
%calculate best delay based on initial conditions
kicktime=.25;  %time from start of motion to impact (s)
bestkickdifx=mountcgdifx;
bestkickdify=mountcgdify+.02;    %2cm below mount
bestkickx=midx+abs(sind(pitchangle)*bestkickdify)*-sign(pitchangle);
bestkicky=midy-abs(cosd(pitchangle)*bestkickdify);




