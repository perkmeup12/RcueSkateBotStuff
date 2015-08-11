%Matthew Perkins
%make an ellipsoid figure
clc;clear;close all

a=.35;              %forward radius (m)
b=.07;              %vertical radius(m)
c=.305;             %side radius (m)


theta=linspace(0,2*pi,1000);

figure
subplot(1,2,1)
%draw the 3 ellipses
x=a*cos(theta);
y=b*sin(theta);
z=c*sin(theta);
z2=c*cos(theta);

plot3(x,zeros(size(x)),y,x,z,zeros(size(x)),zeros(size(x)),z2,y)
hold on
quiver3(0,0,0,a,0,0,'b')
quiver3(0,0,0,0,0,b,'r')
quiver3(0,0,0,0,c,0,'g')

%graph adjustments
set(gca,'YDir','Reverse')
axis equal
title('Ellipsoid')
xlabel('Vehicle x')
ylabel('Vehicle z')
zlabel('Vehicle y')

%cross section
subplot(1,2,2)
plot(x,y)
hold on
quiver(0,0,a,0)
quiver(0,0,0,b)
axis equal
title('cross section')
xlabel('Vehicle x')
ylabel('Vehicle y')



