% The demo loads a burst of images, aligns each image in the burst to a
% common pose and temporally merge all images in a burst to the common pose

clear all
clc

%defining initial variables
n = 5; %number of images in a burst
noisevar = 0.1; %noise variance

image = im2double(imread('.\image.jpg')); %single gold standard image

%% Creating a synthetic burst with translation and noise
for i = 1:n
   burst(:,:,:,i) = imtranslate(image, [i*10,i*10]) + sqrt(noisevar)*randn(size(image));
end

%% visualization of the input burst
figure(1)
imshow(image), title('Original image');
figure(2)
imshow(burst(:,:,:,3)), title('single image in a burst');
figure(3)
imshow(mean(burst,4)), title('average image');

%% Alignment
%initializing variables for alignment
imA = cell(1,n-1);
B = 16; %search space size
S = 7; %tile size

%Initializing error terms for each aligned images to the common pose
MMSE =  zeros(1,n-1); %minimum mean square error

common_pose = burst(:,:,:,n); %defining an image as commonpose

%aligning images in the burst to the commonpose
for i = 1:n-1 
    stack = burst(:,:,:,i);
    [common, a_stack, MSE(i)] = getAlign(common_pose,stack, B, S);
    imA(i) = {a_stack}; %aligned image stack without common_pose
end

%visualization of an aligned image
figure(4)
imshow(cell2mat(imA(n-1))), title('An aligned image');

%% Temporal Merging of aligned stack to common pose

%extracting individual channels for merging
[R0,G0,B0] =  getChan(common);
for i = 1:n-1
    [tempR,tempG,tempB] = getChan(cell2mat(imA(i)));
    Rx(i) = {tempR};
    Gx(i) = {tempG};
    Bx(i) = {tempB};
end

%individually merging each plane
disp('Merging Plane R');
[RimMt, RimMb, RimMs] = getMerge(R0,Rx);
disp('Merging Plane G');
[GimMt, GimMb, GimMs] = getMerge(G0,Gx);
disp('Merging Plane B');
[BimMt, BimMb, BimMs] = getMerge(B0,Bx);

%visualizing merged images
imM1 = cat(3, RimMt, GimMt, BimMt);
figure(5)
imshow(imM1), title('Temporally merged image');

imM2 = cat(3, RimMb, GimMb, BimMb);
figure(6)
imshow(imM2), title('Bilaterally merged image');

imM3 = cat(3, RimMs, GimMs, BimMs);
figure(7)
imshow(imM3), title('Spatially merged image');
