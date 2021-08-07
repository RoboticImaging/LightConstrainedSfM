%script used in reconstruction of 22 bursts for 20 different scenes
clear all
clc

tic
for scene = 1 %1:20 if there are 20 scenes
 for burst = 1 %1:22 if there are 20 bursts

n = 7; %number of images in the burst

%reading raw images within a burst of a particular scene; Burst with no fixed-pattern noise
for frame = 1:n
filename = ['D:\reconstruction\' num2str(scene,'%02d') '\' num2str(burst,'%02d') '\' num2str(frame,'%02d') '.raw'];
stack(:,:,frame) = LFConvertToFloat(LFReadRaw(filename, '16bit', [2992 2500])); %for more details check the documentation from LiFF Toolbox
end


%% Alignment
%initializing variables for alignment
imA = cell(1,n-1);
B = 16; %search space size
S = 7; %tile size

%Initializing error terms for each aligned images to the common pose
MMSE =  zeros(1,n-1); %minimum mean square error

%tile-based hierarchical image alignment
common_pose = stack(:,:,n); %defining an image as commonpose

run Alignment

%% Temporal Merging
%extracting individual channels for merging
for i = 1:n-1
    [tempR1,tempG1,tempG2,tempB1] = getChan(cell2mat(imA(i)));
    Rx(i) = {tempR1};
    Gx(i) = {tempG1};
    Gxx(i) = {tempG2};
    Bx(i) = {tempB1};
end

%Tuning Parameters for Merging
T = 8; %tile size
C = 8; %contribution factor for temporal denoising
Cm = 8; %contribution factor for spatial denoising
Sp = 2; %spatial factor

%individually merging each plane
disp('Merging Plane R');
[RimMt, RimMb, RimMs] = getMerge(RR, Rx, T, C, Cm, Sp, n);
disp('Merging Plane G1');
[G1imMt, G1imMb, G1imMs] = getMerge(RG1, Gx, T, C, Cm, Sp, n);
disp('Merging Plane G2');
[G2imMt, G2imMb, G2imMs] = getMerge(RG2, Gxx, T, C, Cm, Sp, n);
disp('Merging Plane B');
[BimMt, BimMb, BimMs] = getMerge(RB, Bx, T, C, Cm, Sp, n);

%visualizing merged images
imM1 = setChan(RimMt, G1imMt, G2imMt, BimMt); %temporally merged images
imwrite(LFHistEqualize(imM1(1:2:end, 2:2:end)), sprintf('D:\\reconstruction\\results\\%02d\\%02d\\%02d.png', scene, burst, frame));

imM2 = setChan(RimMb, G1imMb, G2imMb, BimMb); %bilateral filtering on temporally merged images
imwrite(LFHistEqualize(imM2(1:2:end, 2:2:end)), sprintf('D:\\reconstruction\\results\\%02d\\%02d\\%02d.png', scene, burst, frame));

imM3 = setChan(RimMs, G1imMs, G2imMb, BimMs); %spatial filtering using weiner filtering on temporally merged images
imwrite(LFHistEqualize(imM3(1:2:end, 2:2:end)), sprintf('D:\\reconstruction\\results\\%02d\\%02d\\%02d.png', scene, burst, frame));

common = setChan(RR, RG1, RG2, RB); 
imwrite(LFHistEqualize(common(1:2:end, 2:2:end)), sprintf('D:\\reconstruction\\results\\%02d\\%02d\\%02d.png', scene, burst, frame)); %conventional noisy common pose
toc

beep
pause(5)
end
end
    

