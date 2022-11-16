%==========================================================================
% Find out the FVCOM grid boundary
%
% input  : x   (x coordinate)
%          y   (y coordinate)
%          nv  (triangle matrix)
%          (the three variables above will be got from fgrid)
% output : bdy_x    (x coordinate of bdy)
%          bdy_y    (y coordinate of bdy)
%          lines_x  (x coordinate of all lines)
%          lines_y  (y coordinate of all lines)
%          bdy_id   (node id of (bdy_x, bdy_y) )
%
% Siqi Li, SMAST
% 2021-03-10
%
% Updates:
% 2021-06-08  Siqi Li  the output is updated in fgrid.
% 2021-06-21  Siqi Li  Re-added the output 'bdy' for replace_river_nml
%==========================================================================
function [bdy_x, bdy_y, lines_x, lines_y, bdy_id, lines_id] = f_calc_boundary(fgrid)
% 
% clc
% clear
% 
% file = '../data/gom3_grid.nc';
% 
% x = ncread(file, 'x');
% y = ncread(file, 'y');
% nv = ncread(file, 'nv');

x = fgrid.x;
y = fgrid.y;
nv = fgrid.nv;

% All lines 
lines = [nv(:,[1 2]); nv(:,[1 3]); nv(:,[2 3])];
% Sort every row
lines = sort(lines, 2);
% Sort in column
lines = sortrows(lines);

% All lines without repeat
[lines_id, i_all] = unique(lines, 'rows');

% Inner lines
lines_in = lines;
lines_in(i_all, :) = [];

% Boundary lines
i_bdy = find(~ismember(lines_id, lines_in, 'rows'));
lines_bdy = lines_id(i_bdy, :);


% Connect the boundary-line points
ibdy = 1;
bdy_id{ibdy} = lines_bdy(1, :);
l0 = lines_bdy(2:end ,:);
while ~isempty(l0)
    [i, j] = find(l0==bdy_id{ibdy}(end));
    if ~isempty(i)
        bdy_id{ibdy}(end+1) = l0(i, 3-j);
        l0(i,:) = [];
    else
        ibdy = ibdy + 1;
        bdy_id{ibdy} = l0(1,:);
        l0(1,:) = [];
    end
end


% % bdy = double(bdy_id{1});
% % bdy_x = x(bdy)';
% % bdy_y = y(bdy)';
% % 
% % for i = 2 : length(bdy_id)
% %     bdy = [bdy NaN double(bdy_id{i}(1:end-1))];
% % %     bdy_x = [bdy_x NaN x(bdy_id{i}(1:end-1))'];
% % %     bdy_y = [bdy_y NaN y(bdy_id{i}(1:end-1))'];
% %     bdy_x = [bdy_x NaN x(bdy_id{i})'];
% %     bdy_y = [bdy_y NaN y(bdy_id{i})'];
% % end
% % 
% % bdy_x = [bdy_x NaN];
% % bdy_y = [bdy_y NaN];
% % 
% % 
% % bdy_x = bdy_x(:);
% % bdy_y = bdy_y(:);

bdy_x{1} = [x(bdy_id{1})' nan];
bdy_y{1} = [y(bdy_id{1})' nan];
tf = ispolycw(bdy_x{1}, bdy_y{1});
if tf==0
    bdy_id{1} = bdy_id{1}(end:-1:1);
    bdy_x{1} = [x(bdy_id{1})' nan];
    bdy_y{1} = [y(bdy_id{1})' nan];
end

for i = 2 : length(bdy_id)
    bdy_x{i} = [x(bdy_id{i})' nan];
    bdy_y{i} = [y(bdy_id{i})' nan];
    
    tf = ispolycw(bdy_x{i}, bdy_y{i});
    
    if tf==1
        bdy_id{i} = bdy_id{i}(end:-1:1);
        bdy_x{i} = [x(bdy_id{i})' nan];
        bdy_y{i} = [y(bdy_id{i})' nan];
    end
    
end

lines_x = fgrid.x(lines_id);
lines_y = fgrid.y(lines_id);

% fgrid.bdy_x = bdy_x;
% fgrid.bdy_y = bdy_y;
% fgrid.lines_x = lines_x;
% fgrid.lines_y = lines_y;
% assignin('caller', inputname(1), fgrid);



% figure
% hold on
% for i = 1 : length(bdy_cell)
%     plot(x(bdy_cell{i}), y(bdy_cell{i}), 'r-')
% end

% figure
% id_nan = find(isnan(bdy));
% k = 1:id_nan(1)-1;
% k = 1:6593;
% pgon = polyshape(bdy_x(k), bdy_y(k));
% plot(pgon, 'LineStyle', 'none')

