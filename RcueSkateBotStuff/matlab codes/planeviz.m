clc;clear;close all;
planeO=[-.1616,0.0472,-0.0944];         %origin of plane  (X,Z,Y)
x=linspace(planeO(1)+.1,planeO(1)-.1,100);
y=linspace(planeO(2)+.1,planeO(2)-.1,100);
[X,Y]=meshgrid(x,y);
t=0;                %time
MS=147000;          %motor speed cnts/s
cnts=101750;        %cnts per 1 rotation
T=cnts/MS;          %period
omega=2*pi/T;       %angular velocity
wheelR=.0254;       %radius of exterior wheel in inches

%plane
figure
planeO=[-.1616,0.0472,-0.0944];         %origin of plane  (X,Z,Y)
PlaneZ=(0.034*(X-planeO(1))-0.07874*(Y-planeO(2)))/0.01387+planeO(3);
surf(X,PlaneZ,Y)
hold on
shading flat
xlabel('x')
ylabel('y')
zlabel('z')
%axis equal

%upper sphere
uxo=cos(omega*t+pi/6)*wheelR;
uyo=sind(omega*t+pi/6)*wheelR;
uzo=0;
usr=.168;
[X1,Y1,Z1]=sphere;
XU=X1*usr+uxo;
YU=Y1*usr+uzo;
ZU=Z1*usr+uyo;
surf(XU,ZU,YU);
% 
%  USZ1=sqrt(usr^2-(X-uxo).^2-(Y-uyo).^2)-uzo;
%  USZ2=-sqrt(usr^2-(X-uxo).^2-(Y-uyo).^2)-uzo;
%  surf(XU,YU,USZ1)
% %  surf(X,Y,USZ2)

%lower sphere
lxo=planeO(1);
lyo=planeO(2);
lzo=planeO(3);
lsr=.04572;
XL=X1*lsr+lxo;
YL=Y1*lsr+lyo;
ZL=Z1*lsr+lzo;
surf(XL,ZL,YL);

% LSZ1=sqrt(lsr^2-(X-lxo).^2-(Y-lyo).^2)-lzo;
% LSZ2=-sqrt(lsr^2-(X-lxo).^2-(Y-lyo).^2)-lzo;
% surf(X,Y,LSZ1)
% surf(X,Y,LSZ2)

