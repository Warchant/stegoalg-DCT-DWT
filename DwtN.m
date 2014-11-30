function [DWT] = DwtN(INP, N, wname)
%% DWT = DwtN(INP, N, wname);
% Returns the N-level wavelet transform of the INP 
% array a by the wavelet filter 'wname'.
%
% DWT.comp = tiledImage;    %% composed image
% DWT.cA   = cA;            %# Approximation coefficient storage
% DWT.cH   = cH;            %# Horizontal detail coefficient storage
% DWT.cV   = cV;            %# Vertical detail coefficient storage
% DWT.cD   = cD;            %# Diagonal detail coefficient storage
%
% DWT.cA{1} -- 1-st dwt2
%       ...   
% DWT.cA{N} -- N-th dwt2
if ~ismatrix(INP)
    error('INP must be a matrix.');
end
if ~isscalar(N) || N < 1
    error('N must be positive a scalar, N>0');
end

% algorithm: 
% http://stackoverflow.com/questions/1119917/applying-matlabs-idwt2-several-times/1121881#1121881


nLevel = N;             %# Number of decompositions
cA = cell(1,nLevel);    %# Approximation coefficient storage
cH = cell(1,nLevel);    %# Horizontal detail coefficient storage
cV = cell(1,nLevel);    %# Vertical detail coefficient storage
cD = cell(1,nLevel);    %# Diagonal detail coefficient storage

nColors = 256;
startImage = INP;

for iLevel = 1:nLevel,  %# Apply nLevel decompositions
  [cA{iLevel},cH{iLevel},cV{iLevel},cD{iLevel}] = dwt2(startImage,wname);
  startImage = cA{iLevel};
end

tiledImage = wcodemat(cA{nLevel},nColors);
for iLevel = nLevel:-1:1,
    [rows,cols] = size(cH{iLevel});
    tiledImage = [tiledImage(1:rows, 1:cols)   wcodemat(cH{iLevel},nColors); ...
                  wcodemat(cV{iLevel},nColors) wcodemat(cD{iLevel},nColors)];
end

DWT.comp = tiledImage;
DWT.cA = cA;
DWT.cH = cH;
DWT.cV = cV;
DWT.cD = cD;