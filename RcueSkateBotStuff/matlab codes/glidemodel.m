%Skate modeling script
clc;clear;close all;
load SWliftdragdata.mat

%assumptions
%no friction force from tail during glide phase
%y reference starts at height of cg at rest. all references from 
%assume constant angle of attack for now
%assume no vertical drag
%assume launch speed of vehicle = max speed of tip of leg


%skate constant values
unladenvehiclemass=4.76;                        %vehicle mass (kg)  (10.5lb in kg)
ballast=5.6;                                    %ballast to counteract buoyant force (kg) (12.35lb in kg)
addedmass=1.19;                                 %added ballast for negative buoyancy (kg) (NOT ACTUAL VALUE)
gravity=-9.81;                                  %acceleration due to gravity (m/s^2)
dwater=1000;                                    %Density of water (kg/m^3)
vehvoleng=632.88;                               %displacement of the vehicle (in^3)
vehvolmet=vehvoleng*1.6387*10^-5;               %displacement of vehicle(m^3)
buoyforce=-vehvolmet*dwater*gravity;            %buoyant force on vehicle
totalmass=unladenvehiclemass+ballast+addedmass; %total mass of the vehicle
gravforce=totalmass*gravity;

AoA=7;  %angle of attack

%% calculate Vo based on motor speed
MS=50000;               %motor speed (cnts/s)
revcnt=101750;          %1 revolution in cnts
omega=2*pi*MS/revcnt;   %motor speed in rad/s
R2=.0254;               %radius of center of exterior wheel to connection, 1inch in m
B=0.04572;              %length from mount to joint (1.8in in m)
C=0.10795;              %length from mount to tip of foot (4.25in in m)
T=2*pi/omega;           %period of leg
t2=0:.001:T;            %time vector for launch speed calculation
theta=asind(R2/B*sin(omega*t2));
thetadot=(R2*omega*cos(omega*t2))./(B*sqrt(1-(R2/B)^2*sin(omega*t2).^2)); %rotational speed of leg
Vtip=-thetadot*C;

%% Launching
dist=abs(sum(Vtip.*.001));
x=cosd(23)*dist;
y=sind(23)*dist;


%% simulation
dt=.01;                     %time step
time=0:dt:1000;            %time vector (s)
%initial conditions
i=0;
%x=0;
%y=0.00001;
Vo=max(Vtip);
%Vo=1;               %initial launch velocity (m/s)  (NOT ACTUAL VALUE)
alphao=23;          %initial launch angle (degrees) (NOT ACTUAL VALUE)
Vx=cosd(alphao)*Vo; %initial horizontal velocity
Vy=sind(alphao)*Vo; %initial vertical velocity

xsave=[];
ysave=[];
Vxsave=[];
Vysave=[];
Axsave=[];
Aysave=[];

%loop


while i<length(time) && y>=0
    i=i+1;
    t=time(i);
    
    
%glide     
%variable forces
Fl1=interp1(SWdatastruct.AoA.data,SWdatastruct.lift.data,AoA,'linear','extrap'); %lift force at one BL/s at current AoA
Fd1=interp1(SWdatastruct.AoA.data,SWdatastruct.drag.data,AoA,'linear','extrap'); %drag force at one BL/s at current AoA
V1=.7112*cosd(AoA); %horizontal velocity of flow test (m/s)
V2=Vx;
liftforce= V2^2*Fl1/V1^2;  %lift force at current speed
vertFd=0;                  %vertical drag force. assumed to be zero
horizFd=-V2^2*Fd1/V1^2;

Ax=(horizFd/totalmass);                              %horizontal acceleration
Ay=(buoyforce+gravforce+vertFd+liftforce)/totalmass; %vertical acceleration


%save variables
xsave=[xsave,x];
ysave=[ysave,y];
Vxsave=[Vxsave,Vx];
Vysave=[Vysave,Vy];
Axsave=[Axsave,Ax];
Aysave=[Aysave,Ay];

%update variables
x=x+Vx*dt;
y=y+Vy*dt;
Vx=Vx+Ax*dt;
Vy=Vy+Ay*dt;
end
%save last variables
xsave=[xsave,x];
ysave=[ysave,y];
Vxsave=[Vxsave,Vx];
Vysave=[Vysave,Vy];
Axsave=[Axsave,Ax];
Aysave=[Aysave,Ay];

xtravel=xsave(end);
xsaveeng=39.37*xsave;
ysaveeng=39.37*ysave;
plot(xsaveeng,ysaveeng)
title('position')
xlabel('x (in)')
ylabel('y (in)')


i
