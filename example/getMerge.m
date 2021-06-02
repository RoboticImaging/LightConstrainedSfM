function [imMt, imMb, imMs] = getMerge(common, a_stack)

%initializing variables for merging
T = 8; %Tile size for merging
C = 100; %variance scaling factor
Cm = 100; %spatial variance scaling factor
Sp = 8; %spatial denoising coefficient
n = size(a_stack,3)+1; %no of images in the burst

%padding images
[aH,aW] = size(mean(common,3));
padm = mod(aH,T);
padn = mod(aW,T);

H = aH + padm;
W = aW + padn;

common = padarray(common,[padm,padn],'replicate','post');

for i = 1:n-1
    aimg = padarray(cell2mat(a_stack(i)),[padm,padn],'replicate','post');
    m_stack(i) = {aimg};
end

%Windowing function to avoid ringing artifacts during merging;  
     % Analysis Window
     w1 = -(T-0.5):(T-0.5);
     w2 = -(T-0.5):(T-0.5);
     [w1,w2] = meshgrid(w1,w2);
     analysis_window = cos(w1*pi/2/T).* cos(w2*pi/2/T);
     
     % Output Window
     w1 = 0:(2*T-1);
     w2 = 0:(2*T-1);
     [w1,w2] = meshgrid(w1,w2);
     output_window = (0.5-0.5*cos(2*pi*(w1+0.5)/2/T)).*(0.5-0.5*cos(2*pi*(w2+0.5)/2/T));
     
     %Spatial Denoising Coefficient
     fsigma = 0:Sp/(2*T):(Sp-Sp/(2*T));
     f = fsigma'*fsigma;

     %Tile-based merging in fourier-domain
for i = 1:T/2:H-T+1 
   for j = 1:T/2:W-T+1 
      ctile = common(i:i+T-1,j:j+T-1);
      fourierC = fft2(ctile,2*T,2*T);
      init_merged = 0; %initializing merged tile
      for index = 1:n-1
          altimage = cell2mat(m_stack(index));
          atile = altimage(i:i+T-1,j:j+T-1);
          fourierA = fft2(atile,2*T,2*T);
          v = var(atile(:)); %calculating noise variance in the image
          Dz = abs(fourierC-fourierA);
          Dzs = Dz.^2;
          Az = Dzs./(Dzs + C*v); %voting contribution
          
          if index == n-1
              merged_a = (fourierC + init_merged + (Az.*fourierC) + ((1-Az).*fourierA))./n;  
          else
              init_merged = init_merged + (Az.*fourierC) + ((1-Az).*fourierA);
         end
      end      
     
      %temporal denoising
     M0 = real(ifft2(merged_a));
     M0 = M0(1:T, 1:T);
     M0img(i:i+T-1,j:j+T-1) = M0(1:T,1:T); %Image created based on DFT voting scheme
   
     M11 = M0;
     M12 = flip(M11,2);
     M21 = flip(M11,1);
     M22 = flip(M21,2);
     
     Mrep=[M11,M12;M21,M22];
     Mw = fftshift(fft2(Mrep)).*analysis_window; 
     
     Mx = Mw.* output_window; 
     Tov = real(ifft2(ifftshift(Mx))); %removing ringing artifacts
     Rov = real(ifft2(fft2(Mrep))); %without removing ringing artifacts
     Iov(i:i+T-1,j:j+T-1) = Tov(1:T,1:T); %Image created after removing overlapping tiles artefacts
     Irov(i:i+T-1,j:j+T-1) = Rov(1:T,1:T); %Image created without removing overlapping tiles artefacts
     
     %spatial denoising
     Mx = fft2(Tov,2*T,2*T);
     Tov_8 = Tov(1:T, 1:T);
     ve = 2*var(Tov_8(:));
     Dz0 = abs(fourierC - Mx); 
     Dz02 = (Dz0).^2;
     v0 = var(Tov_8(:));
     Az0 = (Dz02)./(Dz02 + (Cm*f*v0)) ; %Az0 = (Dz02)./(Dz02 + (f*C*v0/N)+1); 
     TFs = Az0.*Mx;
     Ts = real(ifft2(TFs));
     Is(i:i+T-1,j:j+T-1) = Ts(1:T,1:T); %Image created after spatial denoising

   end
end

imMt = Iov; %Temporal Merged Image
imMb = imbilatfilt(Iov, ve); %Denoising using Bilateral Filter on Temporal Merged Image
imMs = Is; %Final Spatial Image
