clc;clear;close all;
[degs,lift,drag]=textread('skateliftdragdata.txt','%f %f %f','headerlines',1);

SWdatastruct=struct;


for i =1:length(degs)
SWdatastruct.AoA.data(i)=degs(i);
SWdatastruct.lift.data(i)=lift(i);
SWdatastruct.drag.data(i)=drag(i);
end

SWdatastruct.AoA.info='Angle of attack in degrees';
SWdatastruct.lift.info='Lift force (lbf)';
SWdatastruct.drag.info='Drag force (lbf)'; 

save('SWliftdragdata.mat','SWdatastruct')