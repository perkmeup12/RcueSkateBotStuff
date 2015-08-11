%estimation of power needed from motor
%need to calculate speed and force over the entire cycle
clc;clear;close all;

%%
strokemat=[];
strokinmat=[];

for L= [1,2,4,8]
    
for r=[.75,1.25,1.5]

%constants
numberofcycles=4;                   %number of cycles to run
t=linspace(0,.5*numberofcycles,100);%(seconds) time

mconv=1/39.37;                      %conversion constant to meters from inches
f=2;                                %(hz) frequency
omega=360*f;                        %(deg/s) rotational freq
speed=ones(size(t))*(f*pi*2*r*mconv);%(meters/s) speed of connector rod
phi=15;                             %degrees  angle of connector rod at intial conditions
L=L*mconv;                          %(meters) length of connecting rod
beta=30;                            %(degrees) angle between leg piston and bottom.
Fd=5;                               %(newtons) drag force
%%

%calculate path of left side of connector (circle)
theta=-90+omega*t;      %(degrees) angle of drive wheel
LeftY=(r+r.*sind(theta)).*mconv;  %(meters)y coordinate of left side of connector rod
LeftX=(r.*cosd(theta)).*mconv;    %(meters)y coordinate of left side of connector rod

%plot
figure
plot3(LeftX,LeftY,t)
title('Position of Connector rod')
xlabel('X (m)')
ylabel('Y (m)')
zlabel('t (s)')
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
% figure
% plot(t,distance)

%calculate stroke length
stroke=sqrt((max(RightY)-min(RightY))^2+(min(RightX)-max(RightX))^2)
strokin=stroke/mconv
strokemat=[strokemat,stroke];
strokinmat=[strokinmat,strokin];


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

% 
% %motor torque speed plots
% figure
% plot(t,Torque);
% xlabel('t')
% ylabel('Torque (Nm)')
% 
% figure
% plot(ones(size(Torque))*120,Torque)
% xlabel('speed')
% ylabel('Torque')
% hold on
% 
% C13peaktorque=.053;
% C13L19spdtrqgrad=1/(-164.715*141.6119);
% spd=0:5:1500;
% C13trq=C13L19spdtrqgrad*spd+C13peaktorque;
% plot(spd,C13trq,'r')
% 
% C13gradw4gr=C13L19spdtrqgrad*4.28;
% C13trq2=C13gradw4gr*spd+C13peaktorque*4.28;
% plot(spd,C13trq2,'r-.')
% 
% C13gradw5gr=C13L19spdtrqgrad*5.18;
% C13trq3=C13gradw5gr*spd+C13peaktorque*5.18;
% plot(spd,C13trq3,'r--')
% 
% C13gradw7gr=C13L19spdtrqgrad*6.75;
% C13trq4=C13gradw7gr*spd+C13peaktorque*6.75;
% plot(spd,C13trq4,'r.')
% 
% %%flat motor
% 
% EC20peaktorque=.0075;
% EC20spdtrqgrad=-1/(515000);
% trq=EC20spdtrqgrad*spd+EC20peaktorque;
% plot(spd,trq,'g')
% 
% EC20gradw4gr=EC20spdtrqgrad*29;
% EC20trq2=EC20gradw4gr*spd+EC20peaktorque*29;
% plot(spd,EC20trq2,'g-.')
% 
% EC20gradw5gr=EC20spdtrqgrad*53;
% EC20trq3=EC20gradw5gr*spd+EC20peaktorque*53;
% plot(spd,EC20trq3,'g--')
% 
% EC20gradw7gr=EC20spdtrqgrad*62;
% EC20trq4=EC20gradw7gr*spd+EC20peaktorque*62;
% plot(spd,EC20trq4,'g.')
% 
% legend('Goal Torque','C13L19','C13L19w4GR','C13L19w5GR','C13L19w7GR','EC20','EC20w4GR','EC20w5GR','EC20w7GR')
% 
% % forcevec(1)=F1*cosd(connangle);
% % forcevec(2)=F1*sind(connangle);
% % perpvec(1)=cosd(perpangle);
% % perpvec(2)=sind(perpangle);
% 
% 
% 
% 
%%
% %plots
% figure
% subplot(1,3,1)
% plot(t,F1);
% title('Force')
% ylabel('N')
% xlabel('time')
% subplot(1,3,2)
% plot(t,speed)
% title('Speed')
% ylabel('m/s')
% xlabel('time')
% subplot(1,3,3)
% plot(t,power)
% title('Power')
% ylabel('W')
% xlabel('time')
end
end

figure
plot([.75,1.25,1.5],strokinmat(1:3),[.75,1.25,1.5],strokinmat(4:6),...
    [.75,1.25,1.5],strokinmat(7:9),[.75,1.25,1.5],strokinmat(10:12));
xlabel('Wheel radius (in)')
ylabel('Stroke Length (in)')
legend('phi=1','phi=5','phi=15','phi=20')
