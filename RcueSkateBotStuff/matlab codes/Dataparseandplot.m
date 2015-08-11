%Matthew Perkins
%Galil and IMU Data parse and plot
clc;clear;close all;

%define filename time variables
fH=22;
fM=22;
fS=07.897;
fSx=num2str(fS-floor(fS));
initialwait=2.5;                      %initial wait before program starts (3sec)
trimlength=6;                       %video only lasts 4 seconds, we'll take 6 secs of data to be safe


%% open file and parse data
%create file names
imufilename=[num2str(fH),',',num2str(fM),',',sprintf('%02d',floor(fS)),fSx(2:end),'imudata.txt'];
galilfilename=[num2str(fH),',',num2str(fM),',',sprintf('%02d',floor(fS)),fSx(2:end),'galildata.txt'];

%open files and make FID
imuFID=fopen(imufilename);
galilFID=fopen(galilfilename);

%scan file data
imudata=textscan(imuFID,'%f,%f,%f,%6c,%f,%f,%f,%f,%f,%f,%f,%f,%f*%s','headerlines',2);
galildata=textscan(galilFID,'%1c%f,%f,%f,%f %f','headerlines',1);


%assign IMU data to variables
imuH=imudata{:,1};                            %hour from imu file
imuM=imudata{:,2};                            %minute from imu file
imuS=imudata{:,3};                            %second from imu file
imulabel=imudata{:,4};                        %label string
SensorYaw=imudata{:,5};                       %calculated attitude heading angle in degrees
SensorPitch=imudata{:,6};                     %calculated attitude pitch angle in degrees
SensorRoll=imudata{:,7};                      %calculate attitude roll angle in degrees
SensorBodyAccelX=imudata{:,8};                %Linear Accel estimate in body x axis (no gravity) m/s^2
SensorBodyAccelY=imudata{:,9};                %Linear Accel estimate in body y axis (no gravity) m/s^2
SensorBodyAccelZ=imudata{:,10};               %Linear Accel estimate in body z axis (no gravity) m/s^2
SensorGyrox=imudata{:,11};                    %Compensated angular rate in the body X-axis rad/s
SensorGyroy=imudata{:,12};                    %Compensated angular rate in the body Y-axis rad/s
SensorGyroz=imudata{:,13};                    %Compensated angular rate in the body Z-axis rad/s


%assign Galil data to variables
galilH=galildata{:,2};                            %hour from galil file
galilM=galildata{:,3};                            %minute from galil file
galilS=galildata{:,4};                            %second from galil file
galilMotorVelocity=galildata{:,5};                %velocity of motor cnts/s
galilEncoderPosition=galildata{:,6};              %position of motor cnts


%clear data to minimize memory usage
clearvars imudata galildata

%maketimevectors
imutstart=[imuH(1),imuM(1),imuS(1)];
imutimevec=(imuH-imutstart(1))*3600+(imuM-imutstart(2))*60+imuS-imutstart(3);

galiltstart=[galilH(1),galilM(1),galilS(1)];
galiltimevec=(galilH-galiltstart(1))*3600+(galilM-galiltstart(2))*60+galilS-galiltstart(3);

%% trim data

%imu
imuInd=find(imutimevec>initialwait & imutimevec<initialwait+trimlength);
imutimevec=imutimevec(imuInd);
SensorYaw=SensorYaw(imuInd);
SensorPitch=SensorPitch(imuInd);
SensorRoll=SensorRoll(imuInd);
SensorBodyAccelX=SensorBodyAccelX(imuInd);
SensorBodyAccelY=SensorBodyAccelY(imuInd);
SensorBodyAccelZ=SensorBodyAccelZ(imuInd);
SensorGyrox=SensorGyrox(imuInd);
SensorGyroy=SensorGyroy(imuInd);
SensorGyroz=SensorGyroz(imuInd);

%galil
galilInd=find(galiltimevec>initialwait & galiltimevec<initialwait+trimlength);
galiltimevec=galiltimevec(galilInd);
galilEncoderPosition=galilEncoderPosition(galilInd);
galilMotorVelocity=galilMotorVelocity(galilInd);

%% graph
figure
plot(imutimevec,SensorPitch,imutimevec,SensorRoll);
title('Roll and Pitch of the sensor')
xlabel('Time (s)')
ylabel('Degrees')
legend('Pitch','Roll')
grid on

figure
plot(imutimevec,SensorBodyAccelX,imutimevec,SensorBodyAccelY,imutimevec,SensorBodyAccelZ);
title('Inertial Body Accelerations (no Gravity)')
xlabel('Time (s)')
ylabel('Acceleration (m/s^2)')
legend('Body X','Body Y', 'Body Z')
grid on

figure
plot(imutimevec,SensorGyrox,imutimevec,SensorGyroy,imutimevec,SensorGyroz)
title('Angular Rates')
xlabel('Time (s)')
ylabel('Rates (rad/s)')
legend('Gyro X','Gyro Y', 'Gyro Z')
grid on

figure
plot(galiltimevec,galilEncoderPosition)
title('Encoder Position')
xlabel('Time (s)')
ylabel('Position (cnts)')
grid on


figure
plot(galiltimevec,galilMotorVelocity)
title('Motor Speed')
xlabel('Time (s)')
ylabel('Speed (cnts/s)')
grid on

figure
subplot(3,1,1)
plot(imutimevec,SensorPitch,imutimevec,SensorRoll);
title('Roll and Pitch of the sensor')
xlabel('Time (s)')
ylabel('Degrees')
legend('Pitch','Roll')
grid on

subplot(3,1,2)
plot(imutimevec,SensorBodyAccelX,imutimevec,SensorBodyAccelY,imutimevec,SensorBodyAccelZ);
title('Inertial Body Accelerations (no Gravity)')
xlabel('Time (s)')
ylabel('Acceleration (m/s^2)')
legend('Body X','Body Y', 'Body Z')
grid on

subplot(3,1,3)
plot(galiltimevec,galilEncoderPosition)
title('Encoder Position')
xlabel('Time (s)')
ylabel('Position (cnts)')
grid on
