function [R, G1, G2, B] = getChan(I)

R = I(1:2:end, 1:2:end);
G1 = I(1:2:end, 2:2:end);
G2 = I(2:2:end, 1:2:end);
B = I(2:2:end, 2:2:end);

end
