function [out] = NAD (C, S)
if ~isequal(size(C),size(S))
    error('C and S must be a matrices with same number of rows and columns.');
end
C = double(C);
S = double(S);
num = double(abs(C-S));
den = double(abs(C));
for i=1:ndims(C)
    num = sum(num);
    den = sum(den);
end
out = num/den;