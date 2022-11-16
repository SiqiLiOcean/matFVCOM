%==========================================================================
% Find the polygon orders
%
% input  :
%   x   --- x in mat format
%   y   --- y in mat format
% 
% output :
%   p --- polygon struct with orders
%
%
% Line in mat format
%   x = [1 1 1 nan 1 2 3 nan];
%   y = [1 2 3 nan 2 2 2 nan];
% Line in cell format
%   cell_x{1} = [1 1 1 nan];
%   cell_y{1} = [1 2 3 nan];
%   cell_x{2} = [1 2 3 nan];
%   cell_y{2} = [2 2 2 nan];
%
% Siqi Li, SMAST
% 2022-07-13
%
% Updates:
%
%==========================================================================
function p = poly_order(x, y)

% x = [levels.x];
% y = [levels.y];



[cell_x, cell_y] = line_mat2cell(x, y);

n = length(cell_x);

K = zeros(n);
for i = 1 : n
    for j = 1 : n
        if i == j
            K(i,j) = 0;
        else
            in = inpolygon(cell_x{i}(1:end-1), cell_y{i}(1:end-1), cell_x{j}(1:end-1), cell_y{j}(1:end-1));
            if all(in)
                K(i,j) = 1;
            end
        end
    end
end


Class = sum(K, 2) + 1;
Class_max = max(Class);


p = struct([]);
for i = 1 : Class_max

    id = find(Class==i);

    for j = id(:)'
        if mod(i, 2) == 1 % Polygon outer line
            k = find(K(j,:)==1);
            pid = length(p) + 1;
            p(pid).x = cell_x{j}(1:end-1);
            p(pid).y = cell_y{j}(1:end-1);
            p(pid).id = j;
            p(pid).hole = struct([]);
            K(K(:,j)==1,k) = 0;
        else              % Polygon inner line
            k = find(K(j,:)==1);
            pid = find([p.id]==k);
            hid = length(p(pid).hole) + 1;
            p(pid).hole(hid).x = cell_x{j}(1:end-1);
            p(pid).hole(hid).y = cell_y{j}(1:end-1);
            p(pid).hole(hid).id = j;
            K(K(:,j)==1,k) = 0;
        end
    end

end

            

