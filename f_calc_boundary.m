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
% 2022-12-16  Siqi Li  Added global adjustment for bdy_x and bdy_y
%==========================================================================
function [bdy_x, bdy_y, lines_x, lines_y, bdy_id, lines_id] = f_calc_boundary(fgrid, varargin)

varargin = read_varargin(varargin, {'MaxLon'}, {180.});
MinLon = MaxLon - 360.;
MidLon = MaxLon - 180.;
poly0 = polyshape([MinLon MaxLon MaxLon MinLon MinLon], [-90 -90 90 90 -90]);

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
        i = i(1);
        j = j(1);
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


% Adjust the boundary if this is a global grid
if strcmp(fgrid.type, 'Global')
    for i = 1 : length(bdy_x)
        dlon = bdy_x{i}(1:end-1) - bdy_x{i}([2:end-1 1]);
        k = find(abs(dlon)>180);
        if ~isempty(k)
            org_lon = bdy_x{i};
            org_lat = bdy_y{i};
            if mod(length(k),2) == 0 %length(k) == 2
                org_lon1 = org_lon;
                index = [];
                ii = 0;
                while ii<length(k)
                    ii = ii + 1;
                    index = [index k(ii)+1:k(ii+1)];
                    ii = ii + 1;
                end
                if org_lon(k(1)+1) > MidLon
                    org_lon1(index) = org_lon1(index) - 360.;
                    org_lon2 = org_lon1 + 360.;
                else
                    org_lon1(index) = org_lon1(index) + 360.;
                    org_lon2 = org_lon1 - 360.;
                end
                poly1 = polyshape(org_lon1, org_lat, 'KeepCollinearPoints', true);
                poly2 = polyshape(org_lon2, org_lat, 'KeepCollinearPoints', true);
                polyout1 = intersect(poly0, poly1);
                polyout2 = intersect(poly0, poly2);
                bdy_x{i} = [];
                bdy_y{i} = [];
                if ~isempty(polyout1.Vertices)
                    bdy_x{i} = [bdy_x{i} polyout1.Vertices(1:end, 1)' nan];
                    bdy_y{i} = [bdy_y{i} polyout1.Vertices(1:end, 2)' nan];
                end
                if ~isempty(polyout2.Vertices)
                    bdy_x{i} = [bdy_x{i} polyout2.Vertices(1:end, 1)' nan];
                    bdy_y{i} = [bdy_y{i} polyout2.Vertices(1:end, 2)' nan];
                end

            elseif length(k) == 1 % This is Antarctic
                org_lon = org_lon([k+1:end-2 1:k]);
                org_lat = org_lat([k+1:end-2 1:k]);
                if (org_lon(1)>MidLon)
                    org_lon = flip(org_lon);
                    org_lat = flip(org_lat);
                end
                p_lat = interp1([org_lon(end)-360. org_lon(1)], [org_lat(end) org_lat(1)], MinLon);
                bdy_x{i} = [MinLon org_lon MaxLon MaxLon MinLon MinLon nan];
                bdy_y{i} = [ p_lat org_lat  p_lat   -90.   -90.  p_lat nan];

            else
                length(k)
                error('This situation has not been considered.')
            end
        end
    end
end
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

