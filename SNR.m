function [out] = SNR (C, S)
if ~isequal(size(C),size(S))
    error('C and S must be a matrices with same number of rows and columns.');
end
C = double(C);
S = double(S);
num = double(C.^2);
den = double((C-S).^2);
for i=1:ndims(C)
    num = sum(num);
    den = sum(den);
end
out = num/den;