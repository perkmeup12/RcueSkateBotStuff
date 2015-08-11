%simulation

%% constants and variables
close all; clear; clc;
count =1;

Lmax= 36;   %max length of tail (in)
Lmin= 24;   %min length of tail (in)
dL=1;      %L increment size (in)
hmax=5;     %max altitude of body(in)
hmin=1;     %min altitude of body(in)
dh=1;     %h increment size (in)
Emax=50000; %max modulus of elasticity (psi)
Emin=5000;  %min modulus of elasticity (psi)
dE=5000;    %E increment size (psi)

TailLengths = Lmin:dL:Lmax;   %tail length vector
h = hmin:dh:hmax;             %altitude vector
ModE=Emin:dE:Emax;            %modulus of elasticity vector

offsetangle=5;               %degrees
L=33.7;                      %inches


%body geometry
mountloc=18.25;         %inches from nose to leg mounts
bodylength=28;          %length of the skate body
Cgx=14.38;              %body center of gravity location
Cbx=11.812;             %body center of buoyancy location
Cpx=7;                  %body center of pressure location


%tail variables
b=1.5;                          %inches
thickness=.5;                   %inches
I=b^3*thickness/12;             %inertia of a rectangular tail   

               
numpieces=1;                %number of pieces


%
adjustablemass=.5;           %lbf


%create data struct
plotdata.deftheta.info='Angle of deformation of tail';
plotdata.tailmoment.info='Moment created by deflection of tail';
plotdata.bodymoment.info='Moment created by body';
plotdata.momentdiff.info='Tail moment-body moment';
plotdata.theta.info='Max angle of attack where tail counters body';

for i=1:length(TailLengths)
    L=TailLengths(i);
    for j= 1:length(h)
        altitude=h(j);             %inches
        for k=1:length(ModE)
            E=ModE(k);
            EI=E*I;      

AoA=0;                  %restart AoA 
momentdiff=100;

while momentdiff>1;

    AoA=AoA+.01;
    thetatail=AoA+offsetangle; 
%% calculate body moment/force

%bouyant force
Fb=22.87;                  %lbf
Fbdist=abs(Cbx-mountloc);   %inches

%mass force
Fmg=-(Fb+adjustablemass);   %lbf
Fmgdist=abs(Cgx-mountloc);  %inches

%lift force
load SWliftdragdata.mat
Fl=interp1(SWdatastruct.AoA.data,SWdatastruct.lift.data,AoA,'linear','extrap');
Fldist=abs(Cpx-mountloc);       %inches

%Moment
bodymoment=Fb*Fbdist+Fmg*Fmgdist+Fl*Fldist;  %moment on the body


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

%check if stable
momentdiff=abs(tailmoment-bodymoment);

end

AoA
%save data
plotdata.deftheta.data(i,j,k)=deftheta;
plotdata.tailmoment.data(i,j,k)=tailmoment;
plotdata.bodymoment.data(i,j,k)=bodymoment;
plotdata.momentdiff.data(i,j,k)=momentdiff;
plotdata.theta.data(i,j,k)=AoA;

count=count+1;

if count ==100
    save('LEHplotdata.mat','plotdata')
    count=1;
end
        end
    end
end

save('LEHplotdata.mat','plotdata')
[Y,X,Z]=ndgrid(h,TailLengths,ModE);

p=patch(isosurface(h,TailLengths,ModE,plotdata.theta.data,5));
isonormals(h,TailLengths,ModE,plotdata.theta.data,p)
set(p,'FaceColor','red','EdgeColor','none');
camlight 
lighting gouraud
xlabel('h')
ylabel('TailLengths')
zlabel('ModE')



surf(squeeze(plotdata.theta.data(:,3,:)))


% [I,J,K]=find(plotdata.theta.data==5);
% newX=TailLengths(ind);
% newY=h(ind)

