function [FI] = setChan(R, G1, G2, B)

FI = zeros(size(R,1)+size(G2,1), size(R,2)+size(G1,2));
FI(1:2:end, 1:2:end) = R;
FI(1:2:end, 2:2:end) = G1;
FI(2:2:end, 1:2:end) = G2;
FI(2:2:end, 2:2:end) = B;


end
