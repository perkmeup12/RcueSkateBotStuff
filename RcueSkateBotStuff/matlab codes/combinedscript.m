%combined script.

%% static launch phase
%interative solution of tail length
clc;close all; clear;
theta=4;               %degrees  static angle of attack
angleoffset=6;        %angle offset of tail
theta=theta+angleoffset;
thetarad=theta*pi/180;  %radians
altitude=2;             %inches
L=1;                    %inches


%body geometry
mountloc=18.25;         %inches from nose to leg mounts
bodylength=28;          %length of the skate body
Cgx=14.38;              %body center of gravity location
Cbx=11.812;             %body center of buoyancy location
Cpx=7;                  %body center of pressure location


%tail variables
taildiameter = .25;         % inches
E=1000;                     %psi  

%I=pi/4*(taildiameter/2)^4;  %inertia 
b=1.5;                            %inches
thickness=.5;                   %inches
I=b^3*thickness/12;             %inertia of a rectangular tail   

EI=E*I;                     
numpieces=1;                %number of pieces


%
adjustablemass=.5;           %lbf

%% calculate length of tail
hmat=[];
difmat=[];
diff=5;         %exit condition
while diff>.01
    L=L+.01;
    a=L;

    F=thetarad*2*EI/a^2;                        %force applied at tip
    deflection=F*a^2/(6*EI)*(3*L-a);            %deflection of beam
    h=sind(theta)*L-deflection*sind(90-theta);  %vertical distance
    diff=altitude-h;                            %difference from altitude
end
L

%% calculate counter moment

%bouyant force
Fb=22.87;                  %lbf
Fbdist=abs(Cbx-mountloc);   %inches

%mass force
Fmg=-(Fb+adjustablemass);   %lbf
Fmgdist=abs(Cgx-mountloc);  %inches

%Moment
countermoment=Fb*Fbdist+Fmg*Fmgdist;
%countermoment=5;


%% calculate E
xdist=cosd(theta)*L+deflection*cosd(90-theta);
counterforce=countermoment/xdist;

%with multiple tail pieces
counterforce=counterforce/numpieces;

diff2=5;
while diff2>.00001
    EI=E*I;
    F2=thetarad*2*EI/a^2;
    diff2=counterforce-F2;
    E=E+500;
end

E=EI/I %modulus of elasticity
F2
EI




%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%constant glide phase

%geometries

momentdiff=-4;
theta=3;               %degrees

L=22.06;               %length of tail
while momentdiff<0

altitude=4;             %inches

speed=28*cosd(theta);   %in/s
rho=.0361;              %density of water in lb/in^3

%body geometry
mountloc=18.25;         %inches from nose to leg mounts
bodylength=28;          %length of the skate body
Cgx=14.38;              %body center of gravity location
Cbx=11.812;             %body center of buoyancy location
Cpx=7;                  %body center of pressure location

Planarea=.1486;            %in^2

adjustablemass=.5;           %lbf

%tail variables
thetatail=theta+angleoffset;
thetatailrad=thetatail*pi/180;  %radians


%taildiameter = .25;             %inches
%I=pi/4*(taildiameter/2)^4;     %inertia of a rod

b=1.5;                          %inches
thickness=.5;                   %inches
I=b^3*thickness/12;             %inertia of a rectangular tail         


% E= 17000; %23.6*10^6;                    %psi  modulus of elasticity
% EI=2.3906*10^3; %E*I;
%% calculate counter moment/force

%bouyant force
Fb=22.87;                  %lbf
Fbdist=abs(Cbx-mountloc);   %inches

%mass force
Fmg=-(Fb+adjustablemass);   %lbf
Fmgdist=abs(Cgx-mountloc);  %inches

% %Coefficient of Lift
% %y=.083*x+.534   appoximation taken from graph in design doc
% if theta<8
%     Cl=.083*theta+.534;
% else
%     Cl=1.3;
% end
% 
% %Lift force
% Fl=.5*rho*speed^2*Planarea*Cl;  %lbf
% Fldist=abs(Cpx-mountloc);       %inches

%lift force
load SWliftdragdata.mat
Fl=interp1(SWdatastruct.AoA.data,SWdatastruct.lift.data,theta,'linear','extrap');
Fldist=abs(Cpx-mountloc);       %inches

%Moment
countermoment=Fb*Fbdist+Fmg*Fmgdist+Fl*Fldist;  %moment on the body
%countermoment=5;

%% calculate force from tail
a=L;                        %where force is located
%Ftail=thetatailrad*2*EI/a^2;   %force
%deflection=Ftail*a^2/(6*EI)*(3*L-a);            %deflection of beam
% h=sind(thetatail)*L-deflection*sind(90-thetatail);  %vertical distance
% h
deflection=(sind(thetatail)*L-altitude)/sind(90-thetatail); %beam deflection
Ftail=deflection/(a^2)*6*EI/(3*L-a);                        %force from tail
defthetarad=Ftail*a^2/(2*EI);                               %deflected angle
deftheta=defthetarad*180/pi;

xdist=cosd(thetatail)*L+deflection*cosd(90-thetatail);      %horizontal distance to force
tailmoment=Ftail*xdist;                                     %moment caused by deflection of tail


momentdiff=tailmoment-countermoment;
theta=theta+.1;
end

deftheta
tailmoment
countermoment
momentdiff
theta


