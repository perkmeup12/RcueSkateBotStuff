%script to calculate torque and speed at motor due to given tangential
%force at outside foot and angular velocity of the foot.


%givens
Ft=1;   %lbf
thetaLdot=2; %rad/s


%define geometry
R1=1;       %in; radius of exterior wheel
R2=1;       %in; radius of bronze gears
L1=2;       %in; length of inside portion of foot.
L2=4.25;    %in; length of outside portion of foot
thetamin=.87; %rad; minimum angle of the foot
thetatravel=acos((L1^2+L1^2-(2*R1)^2)/(2*L1*l1)); %rad; total travel in radians of foot based on law of cosines
thetamax=thetamin+thetatravel; %rad; maximum angle of foot


thetafres=10;  %value for changing resolution of theta values of foot
thetafvec=linspace(thetamin,thetamax,thetares); % theta values of foot for calculations
for i=1:length(thetafvec)
    thetaf=thetafvec(i);
%Calculate forces
F1t= L2*Ft/L1;  %lbf; tangential force at inside portion of foot (at the ankle)
F1=F1t/sin(theta); %lbf; force along leg
M1=F1*R1;       %lb-ft; moment about axel from leg
M2=M1;          %lb-ft; moment on gears attached to motor and axel.

F1vec(i)=F1;    %lbf; saving forces for each value of theta
M2vec(i)=M2;    %lb-ft; saving moments for each value of theta
end




