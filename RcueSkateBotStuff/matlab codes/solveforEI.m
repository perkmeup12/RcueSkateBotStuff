%interative solution of tail length
clc;close all; clear;
theta=5;                %degrees
thetarad=theta*pi/180;  % radians
altitude=4;             %inches
L=24;                    %inches

taildiameter = .25;     % inches
E=10000;               %psi  .3ish GPa
I=pi/4*(taildiameter/2)^4;  %inertia 
EI=E*I;

hmat=[];
difmat=[];
diff=5;         %exit condition
while diff>.01
    a=L;

    F=thetarad*2*EI/a^2;                        %force applied at tip
    deflection=F*a^2/(6*EI)*(3*L-a);            %deflection of beam
    h=sind(theta)*L-deflection*sind(90-theta); 
    diff=altitude-h;
    hmat=[hmat,h];
    difmat=[difmat,diff];
    EI=EI+1000;
    L
    h
end
L
    
plot(hmat)