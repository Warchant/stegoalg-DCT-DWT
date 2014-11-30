function [] = DetectTransformations(RGB, R)
% parameters
N = 5; % NxN square
n = (N-1)/2;
sigma = 1;

BLUE = double(RGB(:,:,3));

maxsize = floor(size(BLUE,2)*sqrt(2)/4);
if R<10 || R >= maxsize
    error(['R must be 10<=R<' int2str(maxsize)]);
end

center.row = floor(size(BLUE,1)/2);
center.col = floor(size(BLUE,2)/2);

h = R*2;
a = floor(h/sqrt(2));
MAP = zeros(size(BLUE));
for i = sigma+1:size(BLUE,1)-sigma
    for j=sigma+1:size(BLUE,2)-sigma
        %% read one pixel
        C = 0;
        for k = 1:sigma
            C = C + BLUE(i   , i+k ) + ...
                    BLUE(i   , i-k ) + ...
                    BLUE(i+k , i   ) + ...
                    BLUE(i-k , i   );
        end
        C = C / (4 * sigma);
        delta = BLUE(i, j) - C;
        if delta > 0
            MAP(i,j) = 1;
        end
    end
end

% template to compare
E = [1 0 1 0 1; ...
     0 1 0 1 0; ...
     1 0 1 0 1; ...
     0 1 0 1 0; ...
     1 0 1 0 1];
 
spy(MAP,20);

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

hold on;
for i=1:5
    plot(points{i}.col, points{i}.row,'r+');
end
% 
% for i=1:size(points,2)
%     points{i}.status = 0;
%     % template to compare
%     E = [0 0 1 0 0; ...
%          0 1 0 1 0; ...
%          1 0 1 0 1; ...
%          0 1 0 1 0; ...
%          0 0 1 0 0];
%     
%     M = zeros(size(E));
%     for r = 1:N
%         for c = 1:N
%             if E(r,c) == 0
%                 continue;
%             end
%             %% read one pixel
%             C = 0;
%             for j = 1:sigma
%                 C = C + BLUE(points{i}.row-n+r   , points{i}.col-n+c+j ) + ...
%                         BLUE(points{i}.row-n+r   , points{i}.col-n+c-j ) + ...
%                         BLUE(points{i}.row-n+r+j , points{i}.col-n+c   ) + ...
%                         BLUE(points{i}.row-n+r-j , points{i}.col-n+c   );
%             end
%             C = C / (4 * sigma);
%             delta = BLUE(points{i}.row-n+r, points{i}.col-n+c) - C;
%             if delta > 0
%                 M(r,c) = 1;
%             end
%         end
%     end
%     if M==E
%         disp([num2str(i) ' +']);
%         points{i}.status = 1;
%     end
% end