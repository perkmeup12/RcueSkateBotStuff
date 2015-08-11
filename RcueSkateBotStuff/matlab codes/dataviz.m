clear;clc;close all

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


load LEHplotdata1.mat



[Y,X,Z]=ndgrid(h,TailLengths,ModE);

p=patch(isosurface(h,TailLengths,ModE,plotdata.theta.data,7));
isonormals(h,TailLengths,ModE,plotdata.theta.data,p)
set(p,'FaceColor','red','EdgeColor','none');
camlight 
lighting gouraud
xlabel('h')
ylabel('TailLengths')
zlabel('ModE')

[X2,Y2]=meshgrid(ModE,TailLengths);
    figure
for i=1:length(h)
    %figure
    surf(X2,Y2,squeeze(plotdata.theta.data(:,h(i),:)))
    ylabel('L (in)')
    xlabel('E (psi)')
    title(['Theta vs L,E at h= ' num2str(h(i)) ' in'])
    hold on
end



rX=reshape(X,numel(X),1);
rY=reshape(Y,numel(Y),1);
rZ=reshape(Z,numel(Z),1);
rdata=reshape(plotdata.theta.data,numel(plotdata.theta.data),1);
ind=find(rdata>9);
rdata(ind)=9;
% specify the indexed color for each point
icolor = ceil((rdata/max(rdata))*256);

figure;
scatter3(rX,rY,rZ,rdata,icolor);
figure;
scatter3(rX,rY,rZ,rdata,icolor,'filled');
    
    
    