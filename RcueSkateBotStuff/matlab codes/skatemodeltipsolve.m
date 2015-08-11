%Skate modeling script
clc;clear;close all;
load SWliftdragdata.mat
syms X Y Z

%assumptions
%no friction force from tail during glide phase
%y reference starts at height of mount at rest.
%assume constant angle of attack for now
%assume no vertical drag
%only forces during launch are from leg

%skate constant values
gravity=-9.81;                                  %acceleration due to gravity (m/s^2)
dwater=1000;                                    %Density of water (kg/m^3)
vehvoleng=632.88;                               %displacement of the vehicle (in^3)
vehvolmet=vehvoleng*1.6387*10^-5;               %displacement of vehicle(m^3)
buoyforce=-vehvolmet*dwater*gravity;            %buoyant force on vehicle
totalmass=25.77;                                 %total mass of vehicle in kg
gravforce=totalmass*gravity;

%assuming constant angle of attack
AoA=7;  %angle of attack
Fl1=interp1(SWdatastruct.AoA.data,SWdatastruct.lift.data,AoA,'linear','extrap'); %lift force at one BL/s at current AoA
Fd1=interp1(SWdatastruct.AoA.data,SWdatastruct.drag.data,AoA,'linear','extrap'); %drag force at one BL/s at current AoA
V1=.7112*cosd(AoA); %horizontal velocity of flow test (m/s)

%more constants
MS=147000;                          %motor speed (cnts/s)
revcnt=101750;                      %1 revolution in cnts
omega=2*pi*MS/revcnt;               %motor speed in rad/s
R2=.0254;                           %radius of center of exterior wheel to connection, 1inch in m
B=0.04572;                          %length from lower leg mount to joint (1.8in in m)
C=0.10795;                          %length from lower leg mount to tip of foot (4.25in in m)
T=2*pi/omega;                       %period of leg
t2=0:.001:T;                        %time vector for launch speed calculation
alphaleg=23+AoA;                    %angle of leg plane(degrees)
legangletravel=1.1781;              %total travel length of leg in radians
tiptravel=legangletravel*C;
%tiptravelx=max(relativetipmotion.x)-min(relativetipmotion.x);
%tiptravely=max(relativetipmotion.y)-min(relativetipmotion.y);

%% simulation
dt=.001;                            %time step
time=0:dt:2;                        %time vector (s)
time=[time(1),time];
% time=[relativetipmotion.time(1),relativetipmotion.time];
% tipx=[relativetipmotion.x(1),relativetipmotion.x];
% tipy=[relativetipmotion.y(1),relativetipmotion.y];
% vtipx=[0,diff(tipx)/dt];
% vtipy=[0,diff(tipy)/dt];
% atipx=[0,diff(vtipx)/dt];
% atipy=[0,diff(vtipy)/dt];


%initial conditions
i=1;
x=0;
y=0;
Vx=0;
Vy=0;
Ax=0;
Ay=0;
atipy=0;
atipx=0;
Vtipx=0;
Vtipy=0;
vtipx=0;
vtipy=0;
Tipx=0;
Tipy=0;
Atipx=0;
Atipy=0;
Vxrelative=Vx+Vtipx;
phase=0;

%initialize save variables
xsave=[x];
ysave=[y];
Vxsave=[Vx];
Vysave=[Vy];
Axsave=[Ax];
Aysave=[Ay];
Vtipxsave=[Vtipx];
Vtipysave=[Vtipy];
Vxrelativesave=[Vxrelative];
Atipxsave=[Atipx];
Atipysave=[Atipy];

phasesave=[phase];
Tipysave=[];
uxomat=[];
uyomat=[];
% maxtipy=.0373;



while i<length(time)
    i=i+1;
    t=time(i);
    %%      solve for tip position
    %to start the leg at desired position
    phaseshift=-pi/4;
    
    %constants
    wheelR=.0254;       %radius of exterior wheel in m
    tipR=0.10795;       %length from joint to tip of foot
    
    %plane
    planeO=[-.1616,-0.0944,0.0472];         %origin of plane  (X,Z,Y)
    
    %equation for plane
    fcns(1)=0.034*(X-planeO(1))-0.07874*(Y-planeO(2))-0.01387*(Z-planeO(3));
    
    %upper sphere
    shift=pi/2;
    uxo=cos(omega*t+phaseshift)*wheelR;
    uyo=sin(omega*t+phaseshift)*wheelR;
    uzo=0;
    usr=.18415;
    
    %save origin coordinates of upper sphere
    uxomat=[uxomat;uxo];
    uyomat=[uyomat;uyo];
    
    %equation for upper sphere
    fcns(2)=(X-uxo).^2+(Y-uyo).^2+(Z-uzo).^2-usr^2;
    
    %lower
    lxo=planeO(1);
    lyo=planeO(2);
    lzo=planeO(3);
    lsr=.047625;
    
    %equation for lower sphere
    fcns(3)=(X-lxo).^2+(Y-lyo).^2+(Z-lzo).^2-lsr^2;
    
    %solve for intersection of 3 formulas
    [Sx,Sy,Sz]=solve(fcns(1)==0,fcns(2)==0,fcns(3)==0);
    
    %convert to integers
    for index =1:size(Sx,1);
        ax(index)=eval(Sx(index));
        ay(index)=eval(Sy(index));
        az(index)=eval(Sz(index));
    end
    
    %choose desired solution based on slope between origins of the two spheres
    desiredslope=(uxo-planeO(1))/(uzo-planeO(3));
    desired=0;
    index=1;
    while desired==0
        xd=ax(index);
        yd=ay(index);
        zd=az(index);
        if (uxo-xd)/(uzo-zd)<desiredslope
            desired=1;
        end
        index=index+1;
    end
    
    %save coordinates of joint
    jointx=xd;
    jointy=yd;
    jointz=zd;
    
    %tip coordinates
    tipx=planeO(1)+tipR*(planeO(1)-jointx)/lsr;
    tipy=planeO(2)+tipR*(planeO(2)-jointy)/lsr;
    tipz=planeO(3)+tipR*(planeO(3)-jointz)/lsr;
    
    if i>1
        %new speed and acclerations
        vtipx=(Tipx-tipx)/dt;
        vtipy=(Tipy-tipy)/dt;
        
        atipx=(Vtipx-vtipx)/dt;
        atipy=(Vtipy-vtipy)/dt;
    else
        atipx=0;
        atipy=0;
        vtipx=0;
        vtipy=0;
    end
    
    %%
    %velocity of tip relative to ground
    Vxrelative= Vx+vtipx;
    Vyrelative= Vy+vtipy;
    
    
    %acceleration of tip
    Atipx=atipx;
    Atipy=atipy;
    
    %velocity of the tip of the leg relative to the body
    Vtipx=vtipx;                                            %x component of tip velocity
    Vtipy=vtipy;                                            %y component of tip velocity
    
    %tip motion
    Tipx=tipx;
    Tipy=tipy;
    
    %----------------------------------------
    %note:linear approximation of motion of leg. could be improved by using
    %exact motion calculations or interpolating from data set of tip
    %profile
    %-----------------------------
    if i>2
    %if height of mount is
    if y<=(-Tipy) && Vxrelative<=0 && atipx<0
        Vx=-Vtipx;
        Vy=-Vtipy;
        Ax=Atipx;
        Ay=Atipy;
        x=x+Vx*dt;
        y=y+Vy*dt;
        phase=1;
        
    elseif y>0
        % Skate is gliding%%%%%%%%%%%%%%%%%%
        % forces
        liftforce= Vx^2*Fl1/V1^2;  %lift force at current speed
        vertFd=0;                  %vertical drag force. assumed to be zero
        horizFd=-Vx^2*Fd1/V1^2;
        
        %accelerations
        Ax=(horizFd/totalmass);                              %horizontal acceleration
        Ay=(buoyforce+gravforce+vertFd+liftforce)/totalmass; %vertical acceleration
        
        %update variables
        Vx=Vx+Ax*dt;
        Vy=Vy+Ay*dt;
        x=x+Vx*dt;
        y=y+Vy*dt;
        phase=2;
    else
        phase=0;
        y=0;
        Vx=0;
        Vy=0;
    end
    end
    %save variables
    xsave=[xsave,x];
    ysave=[ysave,y];
    Vxsave=[Vxsave,Vx];
    Vysave=[Vysave,Vy];
    Axsave=[Axsave,Ax];
    Aysave=[Aysave,Ay];
    Vtipxsave=[Vtipxsave,Vtipx];
    Vtipysave=[Vtipysave,Vtipy];
    Atipxsave=[Atipxsave,Atipx];
    Atipysave=[Atipysave,Atipy];
    Vxrelativesave=[Vxrelativesave,Vxrelative];

    phasesave=[phasesave,phase];
    Tipysave=[Tipysave,Tipy];
end


xtravel=xsave(end);
averagespeed=xtravel/time(end)
xsaveeng=39.37*xsave;
ysaveeng=39.37*ysave;


%% Plots
suba=3;

subplot(suba,1,1)
plot(time,ysave)
hold on
tipreach=-min(Tipysave);
% plot(time,tipreach,'k--')

title('Vehicle Height above Ground')
xlabel('time (s)')
ylabel('Height (m)')
grid on


subplot(suba,1,2)
% plot(time,Vysave(2:end))
% title('Vertical velocities')
% ylabel('Velocity (m)')
plot(time(2:end),Tipysave)
hold on
plot(time,zeros(size(time)),'k');
xlabel('time (s)')
ylabel('Distance (m)')
title('Vertical Position of Leg Tip Relative to Underwing Mount');
grid on


subplot(suba,1,3)
plot(xsave,ysave)
xlabel('x (m)')
ylabel('y (m)')
title('Vehicle Position')

% subplot(suba,1,4)
% title('1=launch phase, 2=glide phase')
% plot(time,phasesave(2:end))

% figure
% subplot(2,1,1)
% title('Accelerations')
% plot(time,Aysave(2:end))
% xlabel('time (s)')
% ylabel('acceleration (m/s^2)')
% legend('Y direction')
%
% subplot(2,1,2)
% title('thetas')
% plot(time,thetasave(2:end),time,thetadotsave(2:end),time,thetadoubledotsave(2:end))
% hold on
% plot(time,zeros(size(time)),'k')
% xlabel('time')
% ylabel('rad or rad/s')
% legend('theta','thetadot','thetadoubledot')
%
figure
plot(time(2:end),Vxsave(2:end),'--',time(2:end),Vtipxsave(2:end),'-',time(2:end),Vxrelativesave(2:end),time(2:end),Atipxsave(2:end)/max(Atipxsave(2:end)),'g','markersize',.5)
title('Horizontal Velocities and Acceleration')
hold on
%plot([time(1),time(2*floor(length(time)/10)),time(5*floor(length(time)/10)),time(8*floor(length(time)/10)),time(end)],zeros(5),'.k')
xlabel('time (s)')
ylabel('Velocities(m/s)')
legend('Vehicle Velocity','Velocity of leg tip relative to body','Velocity of leg tip relative to body','Scaled Acceleration of leg tip')
grid on




