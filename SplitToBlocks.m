function [BLOCKS, Av_BLOCKS] = SplitToBlocks(INP, N)
%% BLOCKS = SplitToBlocks(INP, N);
% Divides INP matrix into blocks NxN.
% Av_BLOCKS:
%       |  cols   |
%  --  8x8  8x8  8x8  8x1
% rows 8x8  8x8  8x8  8x1
%  --  8x8  8x8  8x8  8x1
%      1x8  1x8  1x8  1x1

if ~ismatrix(INP)
    error('INP must be a matrix.');
end
if N > size(INP,1) || N < 1
    error(['N must be: 1<=N<=' num2str(size(INP,1))]);
end

[rows,cols] = size(INP);
R = floor(rows/N);
C = floor(cols/N);

if rows/N == R
    RR = N*ones(1,R);
else
    RR = [N*ones(1,R) rows-R*N];
end

if cols/N == C
    CC = N*ones(1,C); 
else
    CC = [N*ones(1,C) cols-C*N];
end

BLOCKS = mat2cell(INP,RR,CC);
Av_BLOCKS = BLOCKS(1:R,1:C);
