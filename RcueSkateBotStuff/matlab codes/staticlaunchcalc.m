%interative solution of tail length
close all; clear;
theta=15;               %degrees
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




