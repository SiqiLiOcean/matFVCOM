%==========================================================================
% % Draw FVCOM grid with Orthographic Projection
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% yyyy-mm-dd
%
% Updates:
%
%==========================================================================
function f_ortho_mesh(f, lon0, lat0, varargin)

varargin = read_varargin(varargin, {'Color_land'}, {[0.8706 0.7216 0.5294]});
varargin = read_varargin(varargin, {'Color_grid'}, {[1 0 0]});
varargin = read_varargin(varargin, {'Color_lonlat'}, {[0 0 0]});
varargin = read_varargin(varargin, {'Longitude'}, {[]});
varargin = read_varargin(varargin, {'Latitude'}, {[]});
varargin = read_varargin2(varargin, {'No_FVCOM_Land'});

% Color_land = [0.8706 0.7216 0.5294];
% Color_grid = [1 0 0];
% Color_lonlat = [0 0 0];
% Longitude = [-90 0 90 180];
% Latitude = [-66-34/60 -23-26/60 0 23+26/60 66+34/60];
% lon0 = region(i).lon;
% lat0 = region(i).lat;

fcoast = 'D:\data\gshhs_i.b';
j = 0;
for i = 1 : length(Longitude)
    j = j + 1;
    Line_lonlat(j).lon = repmat(Longitude(i), 1, length(-90:90));
    Line_lonlat(j).lat = -90:90;
end
for i = 1 : length(Latitude)
    j = j + 1;
    Line_lonlat(j).lon = -180:180;
    Line_lonlat(j).lat = repmat(Latitude(i), 1, length(-180:180));
end


% Earth radius (unit : km)
R = 6378.137;

% Generate the grid
[grid.x, grid.y, cos_c] = proj_geo2ortho(lon0, lat0, f.x, f.y);
k = cos_c<0;
grid.x(k) = nan;
grid.y(k) = nan;

% Generate the grid boundary
j = 0;
for i = 1 : length(f.bdy_x)
    [tmpx, tmpy, cos_c] = proj_geo2ortho(lon0, lat0, f.bdy_x{i}(1:end-1), f.bdy_y{i}(1:end-1));
    if any(cos_c>=0)
        j = j + 1;
        bdy(j).x = tmpx;
        bdy(j).y = tmpy;
        bdy(j).lon = f.bdy_x{i}(1:end-1);
        bdy(j).lat = f.bdy_y{i}(1:end-1);
    end
end



% Generate the coastline 
data = gshhs(fcoast);
j = 0;
for i = 1 : length(data)
    [tmpx, tmpy, cos_c] = proj_geo2ortho(lon0, lat0, data(i).Lon(1:end-1), data(i).Lat(1:end-1));
    if any(cos_c>=0)
        j = j + 1;
        coast(j).x = tmpx;
        coast(j).y = tmpy;
    end
end

% Generate the mask
mask_out = [-R R R -R; -R -R R R]';
theta = 0: 0.1: pi*2;
mask_in = R* [cos(theta); sin(theta)]';
mask = polyshape({mask_out(:,1), mask_in(:,1)}, {mask_out(:,2), mask_in(:,2)});

% Generate the Line_lonlat
if exist('Line_lonlat', 'var')
    for i = 1 : length(Line_lonlat)
        [Line_lonlat(i).x, Line_lonlat(i).y] = proj_geo2ortho(lon0, lat0, Line_lonlat(i).lon, Line_lonlat(i).lat);
    end
end

%--------------------------------------------------------------------------
axis([-R R -R R])
axis equal
axis off
axis([-R R -R R])
hold on
% Plot FVCOM grid
patch('Vertices',[grid.x,grid.y], 'Faces',f.nv, ...
      'FaceColor','w', 'FaceAlpha',1, ...
      'EdgeColor',Color_grid, 'LineWidth',0.1);
% Plot FVCOM land
% if isempty(No_FVCOM_Land)
%     for i = 1 : length(bdy)
%         patch(bdy(i).x, bdy(i).y, Color_land, ...
%             'EdgeColor', Color_grid, ...
%             'FaceColor', Color_land, ...
%             'LineWidth', 0.1);
%     end
% end


% Plot GSHHS land
for i = 1 : length(coast)
    patch(coast(i).x, coast(i).y, Color_land, ...
          'EdgeColor', 'k', ...
          'FaceColor', Color_land, ...
          'LineWidth', 0.1);
end
% Plot lines
if exist('Line_lonlat', 'var')
    for i = 1 : length(Line_lonlat)
        color = Color_lonlat;
        linewidth = 0.2;
        linestyle = '-';
        plot(Line_lonlat(i).x, Line_lonlat(i).y, ...
               'color', color, ...
               'linewidth', linewidth, ...
               'linestyle', linestyle)
    end
end
% Plot mask
plot(mask, 'EdgeColor', 'w', ...
           'FaceAlpha', 1, ...
           'FaceColor', 'w');

% set(gcf, 'position', [1 2 885 781])