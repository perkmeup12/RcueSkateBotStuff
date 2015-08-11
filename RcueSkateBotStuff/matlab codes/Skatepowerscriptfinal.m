%estimation of power needed from motor
%need to calculate speed and force over the entire cycle
clc;clear;close all;

%%
%constants
numberofcycles=4;                   %number of cycles to run
t=linspace(0,.5*numberofcycles,100);%(seconds) time
r=1.25;                             %(inches)diameter of drive wheel
mconv=1/39.37;                      %conversion constant to meters from inches
f=2;                                %(hz) frequency
omega=360*f;                        %(deg/s) rotational freq
speed=ones(size(t))*(f*pi*2*r*mconv);%(meters/s) speed of connector rod
phi=15;                             %degrees  angle of connector rod at intial conditions
L=2*mconv;                          %(meters) length of connecting rod
beta=30;                            %(degrees) angle between leg piston and bottom.
Fd=5;                               %(newtons) drag force
%%

%calculate path of left side of connector (circle)
theta=-90-omega*t;      %(degrees) angle of drive wheel
LeftY=(r+r.*sind(theta)).*mconv;  %(meters)y coordinate of left side of connector rod
LeftX=(r.*cosd(theta)).*mconv;    %(meters)y coordinate of left side of connector rod

%plot
plot3(LeftX,LeftY,t)
title('Position of Connector rod')
xlabel('X (m)')
ylabel('Y (m)')
zlabel('time (s)')
hold on

%%
%initial conditions
LeftXo=0;
LeftYo=0;
RightXo=LeftXo+L.*cosd(phi);
RightYo=LeftYo+L.*sind(phi);

%calculate equation for track of leg piston
legslope=-tand(30);
yint=RightYo-legslope*RightXo;

%calculate position of right side of connector pin based on left side, a
%constant connector rod length and a constrained path for the right side
RightX=(-(2.*legslope.*yint-2.*LeftY.*legslope-2.*LeftX)+...   %-b+
    sqrt((2.*legslope.*yint-2.*LeftY.*legslope-2.*LeftX).^2-...%sqrt(b^2
4.*(legslope.^2+1)...                                           %-4A
.*(yint.^2-2.*LeftY.*yint+LeftY.^2+LeftX.^2-L.^2)))...          %C)
    /(2.*(legslope.^2+1));                                      %/2A
A=legslope.^2+1;
B=2.*legslope.*yint-2.*LeftY.*legslope-2.*LeftX;
C=yint.^2-2.*LeftY.*yint+LeftY.^2+LeftX.^2-L.^2;

RightY=legslope.*RightX+yint;

%plot
plot3(RightX,RightY,t,'r')
legend('Left Side', 'Right Side')

%%
%calculate angles and forces
connslope=(RightY-LeftY)./(RightX-LeftX);  %slope of connector rod
connangle=atand(connslope);
alpha=connangle+beta;  %(degrees) angle between connector rod and leg piston
weightoflegandfoot=(.01+.2)*9.81;

F2=ones(size(t))*Fd/cosd(beta);               %force through leg piston
%if leg is traveling upwards, replace drag forces with weight of leg and
%foot
Xchange=diff(RightX);
Ychange=diff(RightY);
ind=find(Ychange>0);
F2(ind)=weightoflegandfoot;

F1= abs(cosd(alpha).*F2);             %force through connecting rod

%check that distance does not change
distance=sqrt((RightY-LeftY).^2+(RightX-LeftX).^2);
figure
plot(t,distance)

%calculate power needed
power=F1.*speed;

%
radialslope=r*sind(theta)/(r*cosd(theta));
perpslope=-1/radialslope;
perpangle=atand(perpslope);
diffangle=connangle-perpangle;
figure
plot(t,theta,t,diffangle,t,atand(connslope))
legend('theta','diffangle','connslope')

perpforce=F1.*cosd(diffangle);
Torque=abs(perpforce)*r*mconv;

figure
plot(t,Torque);
xlabel('Time (s)')
ylabel('Torque (Nm)')

figure
plot(ones(size(Torque))*120,Torque,'LineWidth',4)
xlabel('Speed (rpm)')
ylabel('Torque (Nm)')
hold on

%w10
W10peaktorque=.053;
W10L19spdtrqgrad=1/(-179.1369*141.6119);
spd=0:5:200;
W10trq=W10L19spdtrqgrad*spd+W10peaktorque;
plot(spd,W10trq,'r')

W10gradw4gr=W10L19spdtrqgrad*4.28^2;
W10trq2=W10gradw4gr*spd+W10peaktorque*4.28;
plot(spd,W10trq2,'r-.')

W10gradw5gr=W10L19spdtrqgrad*5.18^2;
W10trq3=W10gradw5gr*spd+W10peaktorque*5.18;
plot(spd,W10trq3,'r--')

W10gradw7gr=W10L19spdtrqgrad*6.75^2;
W10trq4=W10gradw7gr*spd+W10peaktorque*6.75;
plot(spd,W10trq4,'r--.')

%% W20
W20peaktorque=.053;
W20spdtrqgrad=1/(-164.715*141.6119);
W20trq=W20spdtrqgrad*spd+W20peaktorque;
plot(spd,W20trq,'g')

W20gradw4gr=W20spdtrqgrad*4.28^2;
W20trq2=W20gradw4gr*spd+W20peaktorque*4.28;
plot(spd,W20trq2,'g-.')

W20gradw5gr=W20spdtrqgrad*5.18^2;
W20trq3=W20gradw5gr*spd+W20peaktorque*5.18;
plot(spd,W20trq3,'g--')

W20gradw7gr=W20spdtrqgrad*6.75^2;
W20trq4=W20gradw7gr*spd+W20peaktorque*6.75;
plot(spd,W20trq4,'g--.')



legend('Goal Torque','W10','W10w4GR','W10w5GR','W10w7GR','W20','W20w4GR','W20w5GR','W20w7GR')

% forcevec(1)=F1*cosd(connangle);
% forcevec(2)=F1*sind(connangle);
% perpvec(1)=cosd(perpangle);
% perpvec(2)=sind(perpangle);

%% calculate thrust 




%%
%plots
figure
subplot(1,3,1)
plot(t,F1);
title('Force')
ylabel('N')
xlabel('time')
subplot(1,3,2)
plot(t,speed)
title('Speed')
ylabel('m/s')
xlabel('time')
subplot(1,3,3)
plot(t,power)
title('Power')
ylabel('W')
xlabel('time')