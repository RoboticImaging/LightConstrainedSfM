%Initializing Alternate Channels, and aligned rggb-image
AR = cell(1,n-1);
AG1 = cell(1,n-1);
AG2 = cell(1,n-1);
AB = cell(1,n-1);
imA = cell(1,n-1);

[commonR, commonG1, commonG2, commonB] =  getChan(common_pose); %Get Individual Channels

for i = 1:n-1
    [tempAR, tempAG1, tempAG2, tempAB] = getChan(stack(:,:,i));
    AR(i)  = {tempAR};
    AG1(i) = {tempAG1};
    AG2(i) = {tempAG2}; 
    AB(i)  = {tempAB};
end

for i = 1:n-1
   alternativeR = cell2mat(AR(i));  
   [RR, IR] = getAlign(commonR,alternativeR, B, S);

   alternativeG1 = cell2mat(AG1(i));  
   [RG1, IG1] = getAlign(commonG1,alternativeG1, B, S);
    
   alternativeG2 = cell2mat(AG2(i));   
   [RG2, IG2] = getAlign(commonG2,alternativeG2, B, S);
    
   alternativeB = cell2mat(AB(i));    
   [RB, IB] = getAlign(commonB,alternativeB, B, S);

imA(i) = {setChan(IR,IG1, IG2,IB)};
end
