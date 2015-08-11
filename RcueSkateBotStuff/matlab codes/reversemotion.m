%code to calculate the motorspeed profile for a given tip position profile

%note:equation frame of reference is different than matlab plotting norms.
%matlab normally uses x as forward, y as right, z as up. The equation frame
%has x as forward, y as up and z as right; for this reason when plotting
%the z coordinates were inputed as y and y as z

clc;clear;close all;

syms x y
MS=147000;          %motor speed cnts/s
cnts=101750;        %cnts per 1 rotation
T=cnts/MS;          %period
omega=2*pi/T;       %angular velocity
tipR=0.10795;       %length from joint to tip of foot
dt=.001;            %time step
time=linspace(0,T,100);        %time vector
uxomat=[];
uyomat=[];
wheelR=.0254;       %radius of exterior wheel in inches

load cstspdtipmotion.mat

%tip coordinates
tipx=cstspdtipmotion.x;
tipy=cstspdtipmotion.y;
tipz=cstspdtipmotion.z;

%plane
planeO=[-.1616,-0.0944,0.0472];         %origin of plane  (X,Z,Y)

%upper leg constants
uzo=0;
usr=.18415;

%lower leg constants
lsr=.047625;





for index=1:length(time)
    t=time(index);      %time
    
    %calculate joint position
    jointx=planeO(1)-lsr*(tipx(index)-planeO(1))/tipR;
    jointy=planeO(2)-lsr*(tipy(index)-planeO(2))/tipR;
    jointz=planeO(3)-lsr*(tipz(index)-planeO(3))/tipR;
    
    
    %equation for upper circle
    fcns(1)=x.^2+y.^2-wheelR.^2;
    
    %equation for lower sphere
    fcns(2)=(x-jointx)^2+(y-jointy)^2+(0-jointz)^2-usr^2;
    
    %Solve for intesection points
    [Sx,Sy]=solve(fcns(1)==0,fcns(2)==0);
    
    %convert to integers
    for i =1:size(Sx,1);
        ax(i)=eval(Sx(i));
        ay(i)=eval(Sy(i));
    end
    
    %save solutions
    solutionmatx(index,:)=ax;
    solutionmaty(index,:)=ay;
    
    desired=0;
    if index==2
        i=0;
        while desired==0
            i=i+1;
            %determine quadrant at current time
            if solutionmatx(index,i)>0 & solutionmaty(index,i)>0
                q1=1;
            elseif solutionmatx(index,i)<0 & solutionmaty(index,i)>0
                q1=2;
            elseif solutionmatx(index,i)<0 & solutionmaty(index,i)<0;
                q1=3;
            else
                q1=4;
            end
            
            %determine quadrant of previous location
            if solutionmatx(index-1,i)>0 & solutionmaty(index-1,i)>0
                q2=1;
            elseif solutionmatx(index-1,i)<0 & solutionmaty(index-1,i)>0
                q2=2;
            elseif solutionmatx(index-1,i)<0 & solutionmaty(index-1,i)<0;
                q2=3;
            else
                q2=4;
            end
            
            %determine if direction corresponds with correct direction
            if q2<q1 | (q2==4&q1==1)
                desired=1;
            elseif q2==1&q1==1
                if (solutionmaty(index,i)>solutionmaty(index-1,i)) & (solutionmatx(index,i)<solutionmatx(index-1,i))
                    desired=1;
                end
            elseif q2==2&q1==2
                if (solutionmaty(index,i)<solutionmaty(index-1,i)) & (solutionmatx(index,i)<solutionmatx(index-1,i))
                    desired=1;
                end
            elseif q2==3&q1==3
                if (solutionmaty(index,i)<solutionmaty(index-1,i)) & (solutionmatx(index,i)>solutionmatx(index-1,i))
                    desired=1;
                end
            elseif q2==4&q1==4
                if (solutionmaty(index,i)>solutionmaty(index-1,i)) & (solutionmatx(index,i)>solutionmatx(index-1,i))
                    desired=1;
                end
            end
        end
        xd(1)=solutionmatx(index-1,i);
        yd(1)=solutionmaty(index-1,i);
        xd(2)=solutionmatx(index,i);
        yd(2)=solutionmaty(index,i);
        
    elseif index>2
        i=0;
        desired=0;
        while desired==0
            i=i+1;
            %determine quadrant at current time
            if solutionmatx(index,i)>0 & solutionmaty(index,i)>0
                q1=1;
            elseif solutionmatx(index,i)<0 & solutionmaty(index,i)>0
                q1=2;
            elseif solutionmatx(index,i)<0 & solutionmaty(index,i)<0;
                q1=3;
            else
                q1=4;
            end
            
            %determine quadrant of previous location
            if xd(index-1)>0 & yd(index-1)>0
                q2=1;
            elseif xd(index-1)<0 & yd(index-1)>0
                q2=2;
            elseif xd(index-1)<0 & yd(index-1)<0;
                q2=3;
            else
                q2=4;
            end
            
            threshold=.005;
            
            %determine if direction corresponds with correct direction
            if q1==q2+1 | (q2==4&q1==1)
                if sqrt((solutionmaty(index,i)-yd(index-1))^2+(solutionmatx(index,i)-xd(index-1))^2)<threshold
                    desired=1;
                end
            elseif q2==1&q1==1
                if (solutionmaty(index,i)>yd(index-1)) & (solutionmatx(index,i)<xd(index-1))
                    if sqrt((solutionmaty(index,i)-yd(index-1))^2+(solutionmatx(index,i)-xd(index-1))^2)<threshold
                        desired=1;
                    end
                end
            elseif q2==2&q1==2
                if (solutionmaty(index,i)<yd(index-1)) & (solutionmatx(index,i)<xd(index-1))
                    if sqrt((solutionmaty(index,i)-yd(index-1))^2+(solutionmatx(index,i)-xd(index-1))^2)<threshold
                        desired=1;
                    end
                end
            elseif q2==3&q1==3
                if (solutionmaty(index,i)<yd(index-1)) & (solutionmatx(index,i)>xd(index-1))
                    if sqrt((solutionmaty(index,i)-yd(index-1))^2+(solutionmatx(index,i)-xd(index-1))^2)<threshold
                        desired=1;
                    end
                end
            elseif q2==4&q1==4
                if (solutionmaty(index,i)>yd(index-1)) & (solutionmatx(index,i)>xd(index-1))
                    if sqrt((solutionmaty(index,i)-yd(index-1))^2+(solutionmatx(index,i)-xd(index-1))^2)<threshold
                        desired=1;
                    end
                end
            end
        end
        xd(index)=solutionmatx(index,i);
        yd(index)=solutionmaty(index,i);
    end
    
    
end


plot3(tipx,tipz,tipy,'r');
hold on
plot3(xd,zeros(size(xd)),yd)

