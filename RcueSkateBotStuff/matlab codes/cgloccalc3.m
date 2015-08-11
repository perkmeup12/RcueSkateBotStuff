dleg=18.25;                                     %distance to leg mount (in)
gravity=9.81;                                   %m/s^2
buoyforce=101.74;                               %buoyant force on vehicle (N)
cbx=11.8;                                       %center of buoyancy distance (in)
gravforce=109.9701;                             %force of gravity (N)

cbx2=dleg-cbx;

desiredmoment=0;             %lb-in
unladenx=12.34;              %in
unladenmass=10.5;            %lb

fswgt=1.53-.34; %addedsteel mass for negative bouyancy, kg

frontsteelweight=(fswgt)/0.453592;   %lb

% leadweight=1/.453592*0;   %lb
frontsteelx=10;                 %in

%small plate
smallplateweight=7/8; %lbs
smallplatewidth=2.5;        %in
smallplatelength=5.25;      %in
smallplatecgloc=11.5+smallplatelength/2;

%larger plates
steellength=2*(10+9/16);
steelwidth=2.5;
%first steel weight
steelweight1=2*(2.5)/.453592;  %lb


totalmass=(unladenmass+frontsteelweight+smallplateweight+steelweight1);

cgmoment=cbx2*buoyforce-desiredmoment;

desiredx=dleg-cgmoment/(gravforce)

steelx=(totalmass*desiredx-frontsteelweight*frontsteelx-unladenmass*unladenx-smallplateweight*smallplatecgloc)/steelweight1
backedge=steelx+steellength/2

backdif=11.5+smallplatelength-backedge

cgloc=(frontsteelweight*frontsteelx+unladenmass*unladenx+smallplateweight*smallplatecgloc+steelweight1*steelx)/totalmass

