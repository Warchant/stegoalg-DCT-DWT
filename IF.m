function [out] = IF (C, S)
if ~isequal(size(C),size(S))
    error('C and S must be a matrices with same number of rows and columns.');
end
C = double(C);
S = double(S);
num = double((C-S).^2);
den = double(C.^2);
for i=1:ndims(C)
    den = sum(den);
    num = sum(num);
end
out = 1 - num/den;