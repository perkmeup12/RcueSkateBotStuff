clc;close all; clear;


%variables/constants

for onoff = [0,1];
    for r=5%[4,5,6];                %degrees to rotate the foil/angle of attack
        for altitude=4%[3.5,4,4.5];         %assumed altitude in inches
            
            mountloc=18.25;     %inches from nose to leg mounts
            mkrsz=5;           %marker size for cg,cb,cop
            grext= 5;           %distance to extend the ground on both sides of model
            BTLW=1.5;           %body and tail line width
            bodylength=28;      %length of the skate body
            
            Cgx=14.38;          %body center of gravity location
            Cbx=11.812;         %body center of buoyancy location
            Cpx=7;              %body center of pressure location
            
            
            altarrowx=0;        %location of altitude annotation
            %quiver variables
            LL=5;               %arrow length
            mxhdsz=.05;          %maximum head size
            fnscale=.5;         %scaling down the arrows of the line load on tail
            tailscale=.5;       %scale for forces on tail (buoyancy and gravity)
            tbygravratio=.75;   %ratio of sizes of buoyant force to gravitaional
            dragscale=.75;      %scaling down drag force so it doesn't overlap

            %% read NACA file
            %first half is top second is bottom
            [X,Y]=textread('naca4412coordinates.txt','%f %f');
            
            % figure
            % plot(X,Y)
            % axis equal
            
            %% Scaling the figure
            SF=(bodylength/(max(X)-min(X)));
            X=X*SF;
            Y=Y*SF;
            
            %% rotate foil 5 degrees
            R= [cosd(r),-sind(r); sind(r),cosd(r)];
            coord=[X,Y];
            coord5=coord*R;
            
            %new x and y coordinates for foil at 5 degree angle of attack
            x=coord5(:,1);
            y=coord5(:,2);
            
            % figure
            % plot(x,y)
            % axis equal
            
            %% Raising to correct altitude.
            %altitude is assumed to be 4 inches.  altitude is 3.25 with extended legs
            %touching the ground so there is an estimated .75 jump from the legs pushing off the
            %ground.  To touch the ground with an angle of attack of 5 degrees the tail
            %need to be about 3feet plus a few inches to lay along the ground.
            %According to some documentation i found, Skates can have a tail about 1.26
            %times as long as the body.  Ours is closer to 1.5 but i feel thats a
            %reasonable difference to still considered bioinspired.
            
            
            xbottom=x(ceil(length(x)/2):end);
            ybottom=y(ceil(length(y)/2):end);
            YI=interp1(xbottom,ybottom,mountloc); %location of chord line at mountlocation
            y=y+altitude-YI;
            
            % figure
            % plot(x,y)
            % axis equal
            
            %% adding tail
            L1=altitude/sind(r);
            x1=L1/cosd(r)-(bodylength-mountloc);
            
            xtail=[x(1),x(1)+x1,x(1)+x1+1,x(1)+x1+2,x(1)+x1+3];
            ytail=[y(1),0,0,0,0];
            
            cs=spline(xtail,ytail);
            xx=linspace(xtail(1),xtail(end),24);
            xtail=xx;
            ytail=ppval(cs,xx);
            
            %starting to plot
            figure
            hbodytail=plot(x,y,xtail,ytail,'LineWidth',BTLW);
            hold on
            axis equal
            
            %contact point
            ind=find(ytail<.05);
            contactpointx=xtail(ind(1));
            contactpointy=0;
            htcon=plot(contactpointx,contactpointy,'^');
            
            %% adding the ground
            groundx=linspace(-grext,max(xtail)+grext,20);
            groundy=zeros(size(groundx));
            hgr=plot(groundx,groundy,'k');
            
            %% add chord line
            [Val,I]=min(x);
            yzero=interp1(xbottom,ybottom,Val);
            hchord=plot([x(1),Val],[y(1),y(I)],'--r');
            
            
            %% add Cg,Cb,Cop
            
            %body center of gravity
            %Cg estimate.  Put in line with force from legs and on the chord line so that kicking causes
            %minimal rotation.
            
            Cgy=interp1([x(1),Val],[y(1),y(I)],Cgx);
            hcg=plot(Cgx,Cgy,'ok','markersize',mkrsz,'markerfacecolor','b'); %blue
            
            %body center of buoyancy
            %taken from solidworks by changing all parts to same material and finding
            %center of gravity since center of bouyancy is the Cg of the water
            %displaced
            
            Cby=interp1([x(1),Val],[y(1),y(I)],Cbx)+0.478;
            hcb=plot(Cbx,Cby,'ok','markersize',mkrsz,'markerfacecolor','g'); %green
            
            %body center of pressure
            %taken from solidworks flow simulation of skate
            
            Cpy=interp1([x(1),Val],[y(1),y(I)],Cpx);
            hcp=plot(Cpx,Cpy,'ok','markersize',mkrsz,'markerfacecolor','k'); %black
            
            %tail center of gravity/buoyancy
            tcgx=mean(xtail);
            tcgy=interp1(xtail,ytail,tcgx);
            htcg=plot(tcgx,tcgy,'o','markersize',mkrsz,'markerfacecolor','y'); %yellow
            
            
            %% Plot forces
            %Normal force on tail
            fnx=linspace(contactpointx,max(xtail),10);
            fny=ones(size(fnx))*contactpointy;
            fnu=zeros(size(fnx));
            fnv=ones(size(fnx))*LL*fnscale;
            
            %line load
             lnx=[contactpointx,max(xtail)];
             lny=[LL*fnscale,LL*fnscale];
             plot(lnx,lny,'k')
            
            %lift
            fnx(end+1)=Cpx;
            fny(end+1)=Cpy;
            fnu(end+1)=0;
            fnv(end+1)=LL;
            
            %body buoyant force
            fnx(end+1)=Cbx;
            fny(end+1)=Cby;
            fnu(end+1)=0;
            fnv(end+1)=LL;
            
            %body weight
            fnx(end+1)=Cgx;
            fny(end+1)=Cgy;
            fnu(end+1)=0;
            fnv(end+1)=-LL;
            
            %drag
            fnx(end+1)=Cpx;
            fny(end+1)=Cpy;
            fnu(end+1)=LL*dragscale;
            fnv(end+1)=0;
            
            %tail grav
            fnx(end+1)=tcgx;
            fny(end+1)=tcgy;
            fnu(end+1)=0;
            fnv(end+1)=-LL*tailscale;
            
            %tail buoy
            fnx(end+1)=tcgx;
            fny(end+1)=tcgy;
            fnu(end+1)=0;
            fnv(end+1)=LL*tailscale*tbygravratio;
            
            %plot
            %qfn=quiver(fnx,fny,fnu,fnv,LLfraction,'k');
            qfn=quiver(fnx,fny,fnu,fnv,'k','autoscale','off','maxheadsize',mxhdsz);
            %% label forces
            %lift
            text(Cpx,Cpy+5,'F_{lift}')
            text(Cbx,Cby+5,'F_b')
            text(Cpx+1,Cpy+1,'F_D')
            text(Cgx+.5,Cgy-5,'m_bg')
            text(contactpointx-2.5,5*fnscale,'F_N')
            text(tcgx,tcgy+(5*tailscale),'F_{bt}')
            text(tcgx,tcgy-(5*tailscale),'m_tg')
            
            %% legend
            legend([hbodytail;hchord;hgr;htcon;hcg;hcb;htcg;hcp;qfn],'Skate Body','Tail',...
                'Chordline','Ground','Tail Contact Point','Body Center of Gravity',...
                'Body Center of Buoyancy', 'Tail Center of Gravity',...
                'Center of Pressure','Forces')
            
            %% Title and labels
            title('FBD of Skate w/ tail in Glide Phase')
            xlabel('X (in)')
            ylabel('Y (in)')
                
            if onoff==1
                axis on
%                 set(gca,'YMinorTick','on')
%                 grid on
%                 grid minor
            else
                axis off
                whitebg(gcf,'w')
            end
            
            
            %% altitude annotation
            spce=1; %size of space for text 
            %draw horizontal line from mountloc
            plot([0,mountloc],[altitude,altitude],'k')
            
            %insert arrows
            ylimits=ylim;
            ylimdist=abs(ylimits(2)-ylimits(1));
            xlimits=xlim;
            xlimdist=abs(xlimits(2)-xlimits(1));
            
            annotation('arrow',[(altarrowx-xlimits(1))/xlimdist,(altarrowx-xlimits(1))/xlimdist],...
                [((altitude/2)+(spce/2)-ylimits(1))/ylimdist,(altitude-ylimits(1))/ylimdist]);
            text(altarrowx,altitude/2,num2str(altitude));
            annotation('arrow',[(altarrowx-xlimits(1))/xlimdist,(altarrowx-xlimits(1))/xlimdist],...
                [((altitude/2)-(spce/2)-ylimits(1))/ylimdist,(0-ylimits(1))/ylimdist])
            
            
%             text(0,-5,['angle of attack = ' num2str(r) ' degree'])
%             text(0,-7,['altitude = ' num2str(altitude) ' inches'])
% 
        end
    end
end





