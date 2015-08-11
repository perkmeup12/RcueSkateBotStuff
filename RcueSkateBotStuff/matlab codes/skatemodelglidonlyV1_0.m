%Matthew perkins
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
vehvoleng=632.88;                               %displacement of the vehicle (in^3)
vehvolmet=vehvoleng*1.6387*10^-5;               %displacement of vehicle(m^3)
buoyforce=-vehvolmet*dwater*gravity;            %buoyant force on vehicle
buoydist=.01189;                                %distance of buoyant force from cg (m)
vehiclemass=10.36;                              %total mass of vehicle in kg
additionalmass=1.53-.34;                        %additional ballast (kg)
totalmass=vehiclemass+additionalmass;
gravforce=totalmass*gravity;
dragcoeff=1.72;                                 %calculated from SW flow sim
crossarea=.02135;                               %cross sectional area of bottom of vehicle(m^2)
IZZ=.31873;                                     %rotational moment of inertia (Kg*m^2)
mountcgdifx=0.151638;                            %distance between cg and mountlocation (m)
mountcgdify=1.5*2.54/100;                        %vertical distance between cg and mount loc (m)


%assuming constant angle of attack
AoA=1;  %angle of attack
Fl1=interp1(SWdatastruct.AoA.data,SWdatastruct.lift.data,AoA,'linear','extrap') %lift force at one BL/s at current AoA
if Fl1<0
    Fl1=0;
end
Fd1=interp1(SWdatastruct.AoA.data,SWdatastruct.drag.data,AoA,'linear','extrap'); %drag force at one BL/s at current AoA
V1=.7112*cosd(AoA); %horizontal velocity of flow test (m/s)

%dimensions of approximate ellipsoid for added mass force
%calculations
a=.35;              %forward radius (m)
b=.07;              %vertical radius(m)
c=.305;             %side radius (m)
radfunC= @(intx) (dwater*pi)*(1-intx.^2/a)*c;
Vertaddedmass=2*integral(radfunC,0,a);  %ellipsoid approximation

%Vertaddedmass=dwater*pi*a^2;       %flat plate approximation  
%Vertaddedmass=0


%% simulation
dt=.001;                            %time step
time=0:dt:1.5;                        %time vector (s)

%initial conditions
pitchangle=-3;  %deg
i=0;
mountx=0;
mounty=.04;
midx=mountx+abs(sind(pitchangle)*mountcgdify);
midy=mounty+cosd(pitchangle)*mountcgdify*-sign(pitchangle);
x=mountx+(cosd(pitchangle)*mountcgdifx+abs(sind(pitchangle)*mountcgdify));
y=mounty+(sind(pitchangle)*mountcgdifx*sign(pitchangle)+cosd(pitchangle)*mountcgdify*-sign(pitchangle));
Vx=.23;
Vy=.054;
Ax=0;
Ay=0;
phase=0;
u=cosd(pitchangle)*Vx+sind(pitchangle)*Vy;
v=sind(pitchangle)*Vx+cosd(pitchangle)*Vy;
r=0;
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
time=[];
t=0;
while running==1;
    i=i+1;
    time=[time,t];
    
    if y>0 &&mounty>0
        % Skate is gliding%%%%%%%%%%%%%%%%%%
        % forces
        liftforce= u^2*Fl1/V1^2;  %lift force at current speed
        vertFd=.5*dwater*dragcoeff*crossarea*-v;                  %vertical drag force.
        horizFd=-u^2*Fd1/V1^2;

        %accelerations
%         Ax=(horizFd/(totalmass));                              %horizontal acceleration
%         Ay=(buoyforce+gravforce+vertFd+liftforce)/(totalmass+Vertaddedmass); %vertical acceleration
         udot=(horizFd+totalmass*r*v)/totalmass;
         vdot=(buoyforce+gravforce+vertFd+liftforce-(totalmass+Vertaddedmass)*r*u);
         rdot=(buoyforce*buoydist)/IZZ;



        %update variables
        u=u+udot*dt;
        v=v+vdot*dt;
        r=r+rdot*dt;
        Vx=cosd(pitchangle)*u+sind(pitchangle)*v;
        Vy=sind(pitchangle)*u+cosd(pitchangle)*v;
        x=x+Vx*dt;
        y=y+Vy*dt;
        midx=x-cosd(pitchangle)*mountcgdifx;
        midy=y-sind(pitchangle)*mountcgdifx;
        mountx=x-(cosd(pitchangle)*mountcgdifx+abs(sind(pitchangle)*mountcgdify));
        mounty=y-(sind(pitchangle)*mountcgdifx*sign(pitchangle)+cosd(pitchangle)*mountcgdify*-sign(pitchangle));
        pitchangle=pitchangle+r*dt*180/pi;
        phase=2;
    else
        %skate has hit the ground, stopping the vehicle
        phase=0;
        u=0;
        v=0;
        r=0;
        Vx=0;
        Vy=0;
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
    
    %update time
    t=t+dt;
    
end


xtravel=xsave(end);
xsaveeng=39.37*xsave;
ysaveeng=39.37*ysave;

figure
plot(time,ysave(2:end)*100)
title('Vehicle Height above Ground')
xlabel('time (s)')
ylabel('Height (cm)')
grid on

dx=0.46355;     %distance from nose to leg mount
recordedtimes=[2+18/30,2+24/30,2+8/30,1+29/30,2+5/30,2+25/30,2+16/30,2+23/30];
recordedspeeds=dx./recordedtimes;

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
figure
plot(xsave,ysave)
xlabel('x (m)')
ylabel('y (m)')
title('Vehicle Position')
axis equal

figure
orientationx=[xsave;midxsave;mountxsave];
orientationy=[ysave;midysave;mountysave];
plot(orientationx,orientationy);
xlabel('x (m)')
ylabel('y (m)')
title('Vehicle Orientation')
axis equal

figure
plot(time,pitchanglesave(2:end))
xlabel('time (s)')
ylabel('Pitch angle (deg)')

figure
plot(time,rsave(2:end))


