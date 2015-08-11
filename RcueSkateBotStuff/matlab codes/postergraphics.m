clc;clear;close all;

syms x y z
MS=147000;          %motor speed cnts/s
cnts=101750;        %cnts per 1 rotation
T=cnts/MS;          %period
omega=2*pi/T;       %angular velocity
tipR=0.10795;       %length from joint to tip of foot
dt=.001;            %time step
time=linspace(0,T,100);        %time vector
%swtch=1;
uxomat=[];
uyomat=[];


%% additional stuff
            mountloc=18.25;     %inches from nose to leg mounts
            mkrsz=5;           %marker size for cg,cb,cop
            grext= 5;           %distance to extend the ground on both sides of model
            BTLW=1.5;           %body and tail line width
            bodylength=28;      %length of the skate body
            
            Cgx=14.38;          %body center of gravity location
            Cbx=11.812;         %body center of buoyancy location
            Cpx=7;              %body center of pressure location
            
            

            %quiver variables
            LL=5;               %arrow length
            mxhdsz=.05;         %maximum head size
            fnscale=.5;         %scaling down the arrows of the line load on tail
            tailscale=.5;       %scale for forces on tail (buoyancy and gravity)
            tbygravratio=.5;    %ratio of sizes of buoyant force to gravitaional
            dragscale=.75;      %scaling down drag force so it doesn't overlap
            
            %annotation variables
            altarrowx=4;        %location of altitude annotation
            spce=1;             %size of space for text in altitude annotation
            mxhdsz2=.2;         %maximum arrow head size for dimesions
            arclinext=2;        %extension past nose for angle annotation
            arcspace=10;         %space for text in arc annotation
            centerofcurvature=10; % center of arc annotations
            %%
%note:equation frame of reference is different than matlab plotting norms.
%matlab normally uses x as forward, y as right, z as up. The equation frame
%has x as forward, y as up and z as right; for this reason when plotting
%the z coordinates were inputed as y and y as z

for index=1:length(time)
    t=time(index);      %time
    wheelR=.0254;       %radius of exterior wheel in inches
    
    %plane
    planeO=[-.1616,-0.0944,0.0472];         %origin of plane  (X,Z,Y)
    
    %equation for plane
    fcns(1)=0.034*(x-planeO(1))-0.07874*(y-planeO(2))-0.01387*(z-planeO(3));
    
    %upper sphere
    shift=pi/2;
    uxo=cos(omega*t+shift)*wheelR;
    uyo=sin(omega*t+shift)*wheelR;
    uzo=0;
    usr=.18415;
    
    %save origin coordinates of upper sphere
    uxomat=[uxomat;uxo];
    uyomat=[uyomat;uyo];
    
    %equation for upper sphere
    fcns(2)=(x-uxo).^2+(y-uyo).^2+(z-uzo).^2-usr^2;
    
    %lower
    lxo=planeO(1);
    lyo=planeO(2);
    lzo=planeO(3);
    lsr=.047625;
    
    %equation for lower sphere
    fcns(3)=(x-lxo).^2+(y-lyo).^2+(z-lzo).^2-lsr^2;
    
    %solve for intersection of 3 formulas
    [Sx,Sy,Sz]=solve(fcns(1)==0,fcns(2)==0,fcns(3)==0);
    
    %convert to integers
    for i =1:size(Sx,1);
        ax(i)=eval(Sx(i));
        ay(i)=eval(Sy(i));
        az(i)=eval(Sz(i));
    end
    %save solutions
    solutionmatx(index,:)=ax;
    solutionmaty(index,:)=ay;
    solutionmatz(index,:)=az;
    
    %choose desired solution based on slope between origins of the two spheres
    slopemat(index,:)=(ax./az);
    desiredslope(index)=(uxo-planeO(1))/(uzo-planeO(3));
    desired=0;
    i=1;
    desiredmat=zeros(size(ax));
    while desired==0
        xd=ax(i);
        yd=ay(i);
        zd=az(i);
        if (uxo-xd)/(uzo-zd)<desiredslope(index)
            desired=1;
        end
        i=i+1;
    end
    desiredmat(index)=i;
    
    %save coordinates of joint
    jointx(index)=xd;
    jointy(index)=yd;
    jointz(index)=zd;
    
    %tip coordinates
    tipx(index)=planeO(1)+tipR*(planeO(1)-jointx(index))/lsr;
    tipy(index)=planeO(2)+tipR*(planeO(2)-jointy(index))/lsr;
    tipz(index)=planeO(3)+tipR*(planeO(3)-jointz(index))/lsr;
    

end

cstspdtipmotion.x=tipx;
cstspdtipmotion.y=tipy;
cstspdtipmotion.z=tipz;

save('cstspdtipmotionlowres.mat','cstspdtipmotion')
% 
% relativetipmotion.x=tipx-planeO(1);
% relativetipmotion.y=tipy-planeO(2);
% relativetipmotion.z=tipz-planeO(3);
% relativetipmotion.time=time;
% 
% save('relativetipmotion.mat','relativetipmotion')

%calculate angular velocity
dtravel=sqrt(diff(xd)^2+diff(yd)^2+diff(zd)^2);
vel=dtravel/dt;
angvel=vel/usr;

% make animation
for index=1:length(time)
    figure(1)
    plot3([uxomat(index),jointx(index)],[0,jointz(index)],[uyomat(index),jointy(index)],'r');
    hold on
    set(gca,'Ydir','reverse')
%     xlim([-.25,.05])
%     ylim([0,.18])
%     zlim([-.16,.05])
    xlabel('x')
    ylabel('z')
    zlabel('y')
    axis square
    view(-60,25)
    plot3(planeO(1),planeO(3),planeO(2),'k.','markersize',15)
    plot3([jointx(index),tipx(index)],[jointz(index),tipz(index)],[jointy(index),tipy(index)],'g');
    plot3(uxomat,zeros(size(uxomat)),uyomat,'k')
    M(index)=getframe(gcf);
    %close all
end,,
legend('Linkage sweep','Underwing Mount Location','Leg sweep','Linkage Pin Movement','Vehicle Profile')
grid on
title('Area swept by Leg and Linkage Movement')
% save('legmovie.mat','M')
[X,Y]=textread('naca4412coordinates.txt','%f %f');
% figure
% plot(X,Y)
% axis equal

%% Scaling the figure
SF=(bodylength/(max(X)-min(X)));
r=3; %degrees
X=X*SF*0.0254;
Y=Y*SF*0.0254;
R= [cosd(r),-sind(r); sind(r),cosd(r)];
coord=[X,Y];
coord5=coord*R;

%new x and y coordinates for foil at 5 degree angle of attack
X=coord5(:,1);
Y=coord5(:,2);
X=X-(0.51355+lxo);
X=-X;

Y=Y+(0.05405+lyo);
plot3(X,zeros(size(X)),Y,'linewidth',3)
axis equal
%% other plotting
% %change in coordinates over time
% figure
% plot(time,jointx,time,jointy,time,jointz)
% legend('jointx','jointy','jointz')
% xlabel('time')
% ylabel('position (m)')
% 
%plot path in 3 dimensions
figure(2)
plot3(jointx,jointz,jointy,'r','linewidth',2)
set(gca,'Ydir','reverse')
hold on
plot3(planeO(1),planeO(3),planeO(2),'k.','markersize',15)
plot3(uxomat,-.001*ones(size(uxomat)),uyomat,'k','linewidth',2)
plot3(tipx,tipz,tipy,'g','linewidth',2)
plot3(X,zeros(size(X)),Y,'linewidth',2)
plot3([jointx(end),tipx(end)],[jointz(end),tipz(end)],[jointy(end),tipy(end)],'b','linewidth',2);
plot3([uxomat(end),jointx(end)],[0,jointz(end)],[uyomat(end),jointy(end)],'r','linewidth',2)
grid on
axis equal
title('Motion paths in meters')
xlabel('x')
ylabel('z')
zlabel('y')
legend('Flexible joint motion','Underwing mount location','Linkage pin motion','Leg tip motion','Vehicle Profile')

%% more plotting
% figure
% plot(time,tipx,time,(max(abs(tipx))-min(abs(tipx)))/2*sin(omega*time-0.489)-.1623)
% legend('tipx','sinusoid')

 