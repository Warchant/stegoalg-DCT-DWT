clear;
xfile = 'long_MAXSIZE_diff_size_chrstcs.xlsx';
S = [128 256 512 1024 2048];
P = [50 30 10 5];
M = cell(7,1 + numel(S) + numel(P));
format long
for s = 1:numel(S)

    for p = 1:numel(P)
        chr = Insertion(P(p), [S(s) S(s)]);
        M{1, 1+ p + numel(P)*(s-1)} = S(s);
        M{2, 1+ p + numel(P)*(s-1)} = P(p);
        M{3, 1+ p + numel(P)*(s-1)} = chr.ad;
        M{4, 1+ p + numel(P)*(s-1)} = chr.nad;
        M{5, 1+ p + numel(P)*(s-1)} = chr.snr;
        M{6, 1+ p + numel(P)*(s-1)} = chr.if;
        M{7, 1+ p + numel(P)*(s-1)} = chr.mse;
        
    end
end
M{1,1} = 'Img Size';
M{2,1} = 'P';
M{3,1} = 'AD';
M{4,1} = 'NAD';
M{5,1} = 'SNR';
M{6,1} = 'IF';
M{7,1} = 'MSE';

xlswrite(xfile, M);