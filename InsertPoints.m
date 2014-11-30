function [RGB] = InsertPoints(RGB, R)
%% RGB = InsertPoints(RGB, R);
% Insert in center of INP matrix trapeze with an inscribed circle of radius R.
%    _a_    |                   Points:   1___2
%   /   \   | height = 2R                / 5.  \
%  /__2a_\  |                          3/_______\4
%

% parameters
lambda = 0.6;
N      = 5; % NxN square
n      = (N-1)/2;

RED   = double(RGB(:,:,1));
GREEN = double(RGB(:,:,2));
BLUE  = double(RGB(:,:,3));


maxsize = floor(size(RGB,2)*sqrt(2)/4);
if R<10 || R >= maxsize
    error(['R must be 10<=R<' int2str(maxsize)]);
end

center.row = floor(size(BLUE,1)/2);
center.col = floor(size(BLUE,2)/2);

h = R*2;
a = floor(h/sqrt(2));

points = cell(1,5);
%       1__a__2
points{1}.row = floor(center.row - R);
points{1}.col = floor(center.col - a/2);
points{2}.row = floor(center.row - R);
points{2}.col = floor(center.col + a/2);
%  3______2a_______4
points{3}.row = floor(center.row + R);
points{3}.col = floor(center.col - a);
points{4}.row = floor(center.row + R);
points{4}.col = floor(center.col + a);
% center point
points{5}.row = center.row;
points{5}.col = center.col;

for i=1:size(points,2)
    % use Kutter-Jordan-Bossen method to insert points:
    Y = 0.3*RED(points{i}.row, points{i}.col) + 0.59*GREEN(points{i}.row, points{i}.col) + 0.11*BLUE(points{i}.row, points{i}.col);
    
    M = [1 0 1 0 1; ...
         0 1 0 1 0; ...
         1 0 1 0 1; ...
         0 1 0 1 0; ...
         1 0 1 0 1];
     
    for r = 1:N
        for c = 1:N
            if M(r,c) == 1
                BLUE(points{i}.row-n+r, points{i}.col-n+c) = BLUE(points{i}.row-n+r, points{i}.col-n+c) + lambda * Y; % insert 1
            end
        end
    end
%     INP(points{i}.row, points{i}.col) = 255 - INP(points{i}.row, points{i}.col);
end
RGB(:,:,3) = BLUE;