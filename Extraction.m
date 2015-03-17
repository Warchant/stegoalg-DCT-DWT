clear;
% parameters
N     = 10;                      % crop N% from each side
key   = 2014;                    % numerical key for pseudo-random generator
path  = 'coded.bmp';             % path to image with stego
wname = 'db1';                   % wavelet name

% coeficients
u1 = 5;
u2 = 4;
v1 = 4;
v2 = 5;

%% extraction
RGB = imread(path);
RGB = imresize(RGB, [S S]);
YCBCR = rgb2ycbcr(RGB);
Y  = YCBCR(:,:,1);
CB = YCBCR(:,:,2);
CR = YCBCR(:,:,3);

workwith = CB;
% cut N% from each side
workwith = workwith(floor(size(workwith,1)*(N/100)) + double(N==0) : floor(size(workwith,1)*(100-N)/100), ...
                    floor(size(workwith,2)*(N/100)) + double(N==0) : floor(size(workwith,2)*(100-N)/100));

% discrete wavelet transform 
[DWT.cA, DWT.cH, DWT.cV, DWT.cD] = dwt2(workwith,wname);

% divide to 8x8. Av_BLOCKS -- blocks, which is available to insertion
[~, Av_BLOCKS] = SplitToBlocks(DWT.cV,8);

% discrete cosine transform of each block
for i = 1:size(Av_BLOCKS,1)
    for j=1:size(Av_BLOCKS,2)
        Av_BLOCKS{i,j} = dct2(Av_BLOCKS{i,j});
    end
end

% extract
received.bin = '';
rng(key);                                   % start seed (used as key)
queue = randperm(numel(Av_BLOCKS) );        % generates pseudo random non-repeatable sequence of integers
for i=1:numel(Av_BLOCKS)                    % read every block
    OmP = Av_BLOCKS{queue(i)};
    if abs(OmP(u1,v1)) > abs(OmP(u2,v2))
        received.bin = [received.bin '0'];
    else
        received.bin = [received.bin '1'];
    end
end

% if length of received bins isnt divideable by 8, then 
if mod(length(received.bin),8)~=0
    received.bin = received.bin(1:end - mod(length(received.bin),8));
    disp(['New length is: ' ... 
        num2str(length(received.bin))]);
end

% convert vector of bins into string
received.bin = reshape(received.bin,8, length(received.bin)/8)';
for i=1:size(received.bin,1)
    received.dec(i) = bin2dec(received.bin(i,:));
    received.str(i) = char(received.dec(i));
end
disp(received.str)