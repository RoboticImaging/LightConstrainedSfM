function [R, AI, MSE] = getAlign(R, A, B, S)
%This function aligns every image in the burst with the given reference
%image and generate aligned images for merging pipeline.

%initizing variables for alignment
L = 4; %Pyramid Levels
m = 1; %motion vector initiaization for pyramid levels
mv_level = 0; %motion vector initialization in each level

[H,W] = size(mean(A,3));
BA = imresize(A, 2); %Resizing image for sub-pixel alignment

w=fspecial('gaussian',[2 2]);

%Creating Hierarchical coarse-to-fine Gaussian Pyramid
R0=R; 
R1=imresize(imfilter(R0,w),[H/2 W/2]);
R2=imresize(imfilter(R1,w),[H/2/2 W/2/2]);
R3=imresize(imfilter(R2,w),[H/2/2/2 W/2/2/2]);

A0=A; %Fine Level
A1=imresize(imfilter(A0,w),[H/2 W/2]);
A2=imresize(imfilter(A1,w),[H/2/2 W/2/2]);
A3=imresize(imfilter(A2,w),[H/2/2/2 W/2/2/2]); %Coarse Level

%Coarse Level Alignment
H = H/8; %Height of the coarse level image
W = W/8; %Width of the coarse level image

for i = 1:B:H-B+1 %For each first tile of blocks from first to last for rows
      RangeSR = (i-S); %Search range starts
      RangeER = i+B-1+S; %Search range ends
      
      if RangeSR < 1 %If range is out of the image at the beginning, 
          RangeSR = 1; %Start from 1
      end
      if RangeER > H %If range is out of the image at the end, 
          RangeER = H; %End at the end of image
      end
      
   for j = 1:B:W-B+1 %For each first tile of blocks from first to last for columns
      RangeSC = j-S;
      RangeEC = j+B-1+S;
      
         if RangeSC < 1 %Search range begins for each tile
             RangeSC = 1;
         end
        if RangeEC > W %Search range ends for each tile
            RangeEC = W;
        end

      tempR = R3; %template reference for coarse level matching
      tempA = A3; %template alternative for coarse level matching
      RangeS = [RangeSR RangeSC];
      RangeE = [RangeER RangeEC];

            [dx(m), dy(m), mv_search] = getMin(tempR, tempA, B, [i j], RangeS, RangeE); %dx dy are still not cool
            mv_level = mv_search+mv_level; %position of the search

    ox(m) = j;
    oy(m) = i;
    m = m+1;
    %figure, imshow(CI), title('Aligned image at Coarse Level 0') shows
    %exactly how it works
   end
end


    %figure, imshow(A3), title('Alternate at Coarse');
    %hold on
    %quiver(ox,oy,dx,dy);
    %hold off
    %axis on


for ii = L-1:-1:1 %For each Pyramid Level
    dx = dx*2; %4 if image has been divided by 4 at pyramid level |Planar Images|
    dy = dy*2; %4 if image has been divided by 4 at pyramid level |Planar Images|
    line_width = floor(W/B); %No of tiles along x
    H = H*2; %4 if image is divided by 4
    W = W*2; %4 if image is divided by 4
    mm = length(dy);
    m = 1;
    

  for i = 1:B:H-B+1
    baseline = double(uint32(i/2/B))*double(line_width);
      for j = 1:B:W-B+1
         num = floor(baseline+double(uint32(j/2/B))+1);
          
          if num > mm
             num = mm;
          end
          
          RangeSR = i+dy(num)-S; %Each tile gets a tailored search range based on the previous row
          RangeER = i+dy(num)+B-1+S; %Each tile gets a tailored search range based on the previous row
          
          if RangeSR < 1
              RangeSR = 1;
          end
          if RangeER > H
              RangeER = H;
          end
          
          RangeSC = j+dx(num)-S; %Each tile gets a tailored search range based on the previous column
          RangeEC = j+dx(num)+B-1+S; %Each tile gets a tailored search range based on the previous column
          
          if RangeSC < 1
              RangeSC = 1;
          end
          if RangeEC > W
              RangeEC = W;
          end
          
      RangeS = [RangeSR RangeSC];
      RangeE = [RangeER RangeEC];
      
          if ii == 3 %Add pyramids and call conditions to increase pyramid levels
             tempR = R2;
             tempA = A2;
          end
          
          if ii == 2
             tempR = R1;
             tempA = A1;
          end
          
          if ii == 1
             tempR = R0;
             tempA = A0;     
          end

          [direx(m), direy(m), mv_search] = getMin(tempR, tempA, B, [i,j], RangeS, RangeE, 1); 
          mv_level = mv_search+mv_level;

          %Sub-pixel, Change pix values and change resizing to get any sub-level. Half pixel is 2.
          if(ii == 1)
             RangeSR = (i+direy(m))*2-1-2;
             RangeER = (i+direy(m))*2-1+B*2-1+2;
             if RangeSR < 1
                 RangeSR = 1;
             end
             if RangeER > H*2
                 RangeER = H*2;
             end
                 RangeSC = (j+direx(m))*2-1-2;
                 RangeEC = (j+direx(m))*2-1+B*2-1+2;
             if RangeSC < 1
                 RangeSC = 1;
             end
             if RangeEC > W*2
                 RangeEC = W*2;
             end
             
              RangeS = [RangeSR RangeSC];
              RangeE = [RangeER RangeEC];
      
      
             tempR = R0;  
             [direx(m), direy(m), mv_search, AI(i:i+B-1,j:j+B-1,:)] = getMin(tempR, BA, B, [i,j], RangeS, RangeE, 2);
             mv_level = mv_search+mv_level;
             
          end
   ox(m) = j;
   oy(m) = i;
   m = m+1;
     end
 end
    
    dx = direx;
    dy = direy;
    
    %% visualization of motion vector plot
    %if ii==3
    %figure, imshow(A2), title('Alternate at Coarse');
    %hold on
    %quiver(ox,oy,dx,dy);
    %hold off
    %axis on
    %elseif ii==2
    %figure, imshow(A1), title('Alternate at Coarse');
    %hold on
    %quiver(ox,oy,dx,dy);
    %hold off
    %axis on
    %elseif ii==1
    %figure, imshow(A0), title('Alternate at Coarse');
    %hold on
    %quiver(ox,oy,dx,dy);
    %hold off
    %axis on
    %end
    
end

[aH aW] = size(mean(AI,3)) %aligned image size
R = R(1:aH,1:aW,:);
EI = R(:)-AI(:);
E = (abs(EI(:)));
MSE = mean(mean((EI.^2))); %calculating MSE
end