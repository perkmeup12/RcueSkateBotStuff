%Skate modeling script
clc;clear;close all;
load SWliftdragdata.mat

%assumptions
%no friction force from tail during glide phase
%y reference starts at height of cg at rest. all references from
%assume constant angle of attack for now
%assume no vertical drag
%assume launch speed of vehicle = max speed of tip of leg
%only forces during launch are from leg

%skate constant values
unladenvehiclemass=4.76;                        %vehicle mass (kg)  (10.5lb in kg)
ballast=5.6;                                    %ballast to counteract buoyant force (kg) (12.35lb in kg)
addedmass=.85;%1.19;                                   %added ballast for negative buoyancy (kg) (NOT ACTUAL VALUE)
gravity=-9.81;                                  %acceleration due to gravity (m/s^2)
dwater=1000;                                    %Density of water (kg/m^3)
vehvoleng=632.88;                               %displacement of the vehicle (in^3)
vehvolmet=vehvoleng*1.6387*10^-5;               %displacement of vehicle(m^3)
buoyforce=-vehvolmet*dwater*gravity;            %buoyant force on vehicle
totalmass=unladenvehiclemass+ballast+addedmass; %total mass of the vehicle
gravforce=totalmass*gravity;                    %gravitational force

%assuming constant angle of attack
AoA=7;  %angle of attack
Fl1=interp1(SWdatastruct.AoA.data,SWdatastruct.lift.data,AoA,'linear','extrap'); %lift force at one BL/s at current AoA
Fd1=interp1(SWdatastruct.AoA.data,SWdatastruct.drag.data,AoA,'linear','extrap'); %drag force at one BL/s at current AoA
V1=.7112*cosd(AoA); %horizontal velocity of flow test (m/s)
Msmat=150000:-500:145000;
totalzmat=[];
%more constants
for ind=1:length(Msmat)
    MS=Msmat(ind);
    %MS=130000;               %motor speed (cnts/s)
    revcnt=101750;          %1 revolution in cnts
    omega=2*pi*MS/revcnt;   %motor speed in rad/s
    R2=.0254;               %radius of center of exterior wheel to connection, 1inch in m
    B=0.04572;              %length from mount to joint (1.8in in m)
    C=0.10795;              %length from mount to tip of foot (4.25in in m)
    T=2*pi/omega;           %period of leg
    t2=0:.001:T;            %time vector for launch speed calculation
    alphaleg=23;          %initial launch angle (degrees) (NOT ACTUAL VALUE)
    legangletravel=1.1781;     %radians
    tiptravel=legangletravel*C;
    tiptravelx=tiptravel*cosd(alphaleg);
    tiptravely=tiptravel*sind(alphaleg);
    
    %% Launching
    % dist=sum(Vtip(floor(length(Vtip)/2):end).*.001)
    %  x=cosd(alphaleg)*dist;
    %  y=sind(alphaleg)*dist;
    
    
    %% simulation
    dt=.001;                     %time step
    time=0:dt:15;            %time vector (s)
    %initial conditions
    i=0;
    x=0;
    y=0;
    Vx=0;
    Vy=0;
    Ax=0;
    Ay=0;
    Vtipx=0;
    Vtipy=0;
    theta=-33.749*pi/180;
    thetadot=0;
    thetadoubledot=0;
    Vxrelative=Vx+Vtipx;
    phase=0;
    
    %Vo=max(Vtip);
    %Vo=1;               %initial launch velocity (m/s)  (NOT ACTUAL VALUE)
    
    %Vx=cosd(alphao)*Vo; %initial horizontal velocity
    %Vy=sind(alphao)*Vo; %initial vertical velocity
    
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
    thetasave=[theta];
    thetadotsave=[thetadot];
    thetadoubledotsave=[thetadoubledot];
    phasesave=[phase];
    Tipysave=[];
    
    maxtipy=.0373;
    %loop
    
    
    while i<length(time)
        i=i+1;
        t=time(i);
        Vxrelative= Vx+Vtipx;           %velocity of tip relative to ground
        Vyrelative= Vy+Vtipy;
        
        phaseshift=-pi/4-legangletravel/4;                                                               % to start the leg forward with zero speed at time t=0
        theta=asin(R2/B*sin(omega*t+phaseshift));                                       % angle of leg
        thetadot=(R2*omega*cos(omega*t+phaseshift))./(B*sqrt(1-(R2/B)^2*sin(omega*t+phaseshift).^2)); %rotational speed of leg
        thetadoubledot=(R2^3*omega^2*sin(omega*t)*cos(omega*t)^2)/...                   %radial accleration
            (B^3*(1-(R2^2*(sin(omega*t))^2/B^2))^(3/2))-(R2*omega^2*sin(omega*t))/...
            (B*sqrt(1-(R2^2*(sin(omega*t))^2)/B^2));
        Vtip=-thetadot*C;                                                               %velocity of the tip of the leg
        Vtipx=cosd(alphaleg)*Vtip;                                                      %xcomponent of tip velocity
        Vtipy=sind(alphaleg)*Vtip;                                                      % y component of tip velocity
        
        %position of leg in y direction
        %     if theta>legangletravel/4
        Tipy=sind(alphaleg)*((theta+legangletravel/4)*C);
        %     else
        %         Tipy=0;
        %     end
        
        
        if y<=(Tipy) && Vxrelative<=0 && theta>(-legangletravel/4) && theta<0
            Vx=-Vtipx;
            Vy=-Vtipy;
            Ax=cosd(alphaleg)*(C*thetadoubledot);
            Ay=sind(alphaleg)*(C*thetadoubledot);

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

            if y<=0
                y=0;
                Vx=0;
                Vy=0;
            else
                Vx=Vx+Ax*dt;
                Vy=Vy+Ay*dt;
                x=x+Vx*dt;
                y=y+Vy*dt;
            end
            phase=2;
        else
            phase=0;
            y=0;
            Vx=0;
            Vy=0;
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
        Vxrelativesave=[Vxrelativesave,Vxrelative];
        thetasave=[thetasave,theta];
        thetadotsave=[thetadotsave,thetadot];
        thetadoubledotsave=[thetadoubledotsave,thetadoubledot];
        phasesave=[phasesave,phase];
        Tipysave=[Tipysave,Tipy];
    end
 figure   
    suba=3;

subplot(suba,1,1)
plot(time,ysave(2:end))
hold on
tipreach=max(Tipysave);
plot(time,tipreach,'k--')

title('position')
xlabel('time (s)')
ylabel('y (m)')

subplot(suba,1,2)
% plot(time,Vysave(2:end))
% title('Vertical velocities')

% ylabel('Velocity (m)')
plot(time,Tipysave)
hold on
plot(time,zeros(size(time)),'k');
xlabel('time (s)')
ylabel('y position')
title('vertical position of tip');

subplot(suba,1,3)
plot(time,Vxsave(2:end),'--',time,Vtipxsave(2:end),'-',time,Vxrelativesave(2:end))
title('Velocities')
hold on
plot(time,zeros(size(time)),'--k')
xlabel('time (s)')
ylabel('Velocity(m/s)')
legend('Vehicle','Vtipbodyrelative','Vtipgroundrelative')
    
    xtravel=xsave(end);
    averagespeed=xtravel/time(end)
    xsaveeng=39.37*xsave;
    ysaveeng=39.37*ysave;
    
    totalz=0+length(find(ysave<=0));
    totalzmat=[totalzmat,totalz];
end
[V,VI]=min(totalzmat);
bestMS=Msmat(VI)
%% Plots
suba=3;

subplot(suba,1,1)
plot(time,ysave(2:end))
hold on
tipreach=max(Tipysave);
plot(time,tipreach,'k--')

title('position')
xlabel('time (s)')
ylabel('y (m)')

subplot(suba,1,2)
% plot(time,Vysave(2:end))
% title('Vertical velocities')

% ylabel('Velocity (m)')
plot(time,Tipysave)
hold on
plot(time,zeros(size(time)),'k');
xlabel('time (s)')
ylabel('y position')
title('vertical position of tip');

subplot(suba,1,3)
plot(time,Vxsave(2:end),'--',time,Vtipxsave(2:end),'-',time,Vxrelativesave(2:end))
title('Velocities')
hold on
plot(time,zeros(size(time)),'--k')
xlabel('time (s)')
ylabel('Velocity(m/s)')
legend('Vehicle','Vtipbodyrelative','Vtipgroundrelative')

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
% figure
% plot(xsave,ysave)
% xlabel('x (m)')
% ylabel('y (m)')
% title('Position')
% axis equal




