% parameters
P     = 15;                       % power of insertion
N     = 10;                       % crop N% from each side
key   = 2014;                     % key for pseudo-random generator
wname = 'db1';                    % wavelet name
inppath  = 'lena-color.bmp';      % input image path
outpath  = 'coded.bmp';           % output image path
message.text = 'hello world, my name is Bogdan, here is my hidden message!';

% coeficients
u1 = 5;
u2 = 4;
v1 = 4;
v2 = 5;

%% image preprocessing
% read image
RGB = imread(inppath);
[imrows, imcols, ~]=size(RGB);
if imrows < 16 || imcols < 16
    error('Rows and cols of the image must be >=16!');
end

YCBCR = rgb2ycbcr(RGB);
Y  = YCBCR(:,:,1);
CB = YCBCR(:,:,2);
CR = YCBCR(:,:,3);

workwith = CB;

% cut N% from each side
workwith = workwith(floor(size(workwith,1)*(N/100)) + double(N==0) : floor(size(workwith,1)*(100-N)/100), ...
                    floor(size(workwith,2)*(N/100)) + double(N==0) : floor(size(workwith,2)*(100-N)/100));

%% message preprocessing
message.dec = zeros(1, size(message.text,2));
message.bin = '';
for i=1:size(message.text,2)
    message.dec(i) = double(message.text(i));
    message.bin = [message.bin dec2bin(message.dec(i),8)];
end

%% insertion
% discrete wavelet transform 
[DWT.cA, DWT.cH, DWT.cV, DWT.cD] = dwt2(workwith,wname);

% divide to 8x8. Av_BLOCKS -- blocks, which is available to insertion
[BLOCKS, Av_BLOCKS] = SplitToBlocks(DWT.cV,8);

% discrete cosine transform of each block
for i = 1:size(Av_BLOCKS,1)
    for j=1:size(Av_BLOCKS,2)
        Av_BLOCKS{i,j} = dct2(Av_BLOCKS{i,j});
    end
end

% can we insert all message?
capacity_bit = numel(Av_BLOCKS);
toinsert_bit = numel(message.bin);
if capacity_bit < toinsert_bit
    error(['Image capacity:           ' num2str(capacity_bit) ' bit' 10 ...
           'You are trying to insert: ' num2str(toinsert_bit) ' bit' 10 ...
           'Reduce message length!']);
end

% insertion
rng(key);                                   % start seed (used as key)
queue = randperm(numel(Av_BLOCKS));         % generates pseudo random non-repeatable sequence of integers
for i=1:numel(Av_BLOCKS)                 
    OmP = Av_BLOCKS{queue(i)};

    w1 = abs(OmP(u1,v1));
    w2 = abs(OmP(u2,v2));

    if OmP(u1,v1)>=0
        z1 = 1;
    else
        z1 = -1;
    end

    if OmP(u2,v2)>=0
        z2 = 1;
    else
        z2 = -1;
    end
    
    if i > length(toinsert_bit)
        break;
    end
    
    bit = message.bin(i);
    if bit == '0'
        if w1-w2 <= P
            w1 = P + w2 + 1;
        end
    else
        if w1-w2 >= -P
            w2 = P + w1 + 1;
        end
    end

    OmP(u1,v1) = z1*w1;
    OmP(u2,v2) = z2*w2;
    Av_BLOCKS{queue(i)} = OmP;
end

% copy data from available blocks to all blocks and IDCT
for i=1:size(Av_BLOCKS,1)
    for j=1:size(Av_BLOCKS,2)
        Av_BLOCKS{i,j} = idct2(Av_BLOCKS{i,j});
        BLOCKS{i,j} = Av_BLOCKS{i,j};
    end
end

% make matrix from cells
DWT.cV = cell2mat(BLOCKS);

% idwt
workwith = idwt2(DWT.cA,DWT.cH,DWT.cV,DWT.cD,wname);

% add N% pixels to the image and insert it into CB
CB(floor(size(CB,1)*(N/100)) + double(N==0) : floor(size(CB,1)*(100-N)/100), ...
   floor(size(CB,2)*(N/100)) + double(N==0) : floor(size(CB,2)*(100-N)/100)) = workwith(:,:);

% new YCBCR
YCBCR_C(:,:,1) = Y;
YCBCR_C(:,:,2) = CB;
YCBCR_C(:,:,3) = CR;

RGB_C = ycbcr2rgb(YCBCR_C);

% save image
imwrite(RGB_C,outpath);

%% characteristics
chr.ad  = AD(RGB,RGB_C);
chr.nad = NAD(RGB,RGB_C);
chr.snr = SNR(RGB,RGB_C);
chr.if  = IF(RGB,RGB_C);
chr.mse = MSE(RGB,RGB_C);

format long

disp([   ...
'AD: ' 9 ...
num2str(chr.ad) 10 ... 
'NAD:' 9 ...
num2str(chr.nad) 10 ...
'SNR:' 9 ...
num2str(chr.snr) 10 ...
'IF: ' 9 ...
num2str(chr.if) 10 ...
'MSE: ' 9 ...
num2str(chr.mse) 10
]);