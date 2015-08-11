desiredx=12;             %in
backdif=-10;

while abs(backdif+6.9)>.001
    desiredx=desiredx+.001;
unladenx=12.34;              %in
unladenmass=10.5;            %lb

fswgt=1.53; %addedsteel mass for negative bouyancy, kg

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

steelx=(totalmass*desiredx-frontsteelweight*frontsteelx-unladenmass*unladenx-smallplateweight*smallplatecgloc)/steelweight1
backedge=steelx+steellength/2

backdif=11.5+smallplatelength-backedge

cgloc=(frontsteelweight*frontsteelx+unladenmass*unladenx+smallplateweight*smallplatecgloc+steelweight1*steelx)/totalmass

end
backdif
desiredx