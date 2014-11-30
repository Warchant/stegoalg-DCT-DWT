function [out] = AD (C, S)
if ~isequal(size(C),size(S))
    error('C and S must be a matrices with same number of rows and columns.');
end
C = double(C);
S = double(S);
[rows,cols] = size(C);
out = double(abs(C-S)) / (rows*cols);
for i=1:ndims(C)
    out = sum(out);
end