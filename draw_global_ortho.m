%==========================================================================
% Draw Global FVCOM grid using the orthographic projection.
%
% Siqi Li, SMAST
% 2021-06-29
%
% Updates:
%
%==========================================================================
clc
clear

%--------------------------------------------------------------------------
% Input file: GSHHS coastline file (b format)
fcoast = 'D:\Dropbox\tools\matFVCOM\data\gshhs_i.b';

% Input file: FVCOM grid file (grd, 2dm or nc)
fgrid = './Global_nest_combine20_refine_cricle_LL.2dm';

% Output figure file
ffig = './GLB_414139.png';
% Output figure resolution
Resolution = 1200;

% Center longitude and latitude
lon0 = -80;
lat0 = 23.5;

% More lines
% lines is a cell, containing the longitude and latitude of lines:
% [ lon_1 lon_2 ... lon_n;
%   lat_1 lat_2 ... lat_n ]
lines(1).line = [-180:180; repmat(0, 1, length(-180:180))];         % Equator
lines(2).line = [-180:180; repmat(23+26/60, 1, length(-180:180))];  % Tropic of Cancer
lines(3).line = [-180:180; repmat(66+34/60, 1, length(-180:180))];  % Arctic Circle
lines(4).line = [-180:180; repmat(-23-26/60, 1, length(-180:180))]; % Tropic of Capricorn
lines(5).line = [-180:180; repmat(-66-34/60, 1, length(-180:180))]; % Antarctic Circle
lines(6).line = [repmat(0, 1, length(-90:90)); -90:90];             % Prime Meridian
lines(7).line = [repmat(90, 1, length(-90:90)); -90:90];            % Prime Meridian
lines(8).line = [repmat(180, 1, length(-90:90)); -90:90];           % Prime Meridian
lines(9).line = [repmat(-90, 1, length(-90:90)); -90:90];           % Prime Meridian
load('gom_bdy.mat');
lines(10).line = [gom_bdy_x'; gom_bdy_y'];
lines(10).color = 'b';
lines(10).linewidth = 3;




% Land color
color_land  = [0.8706 0.7216 0.5294];   % tan
color_grid  = [1 0 0];                  % red
color_lines = [0 0 0];                  % black

% Earth radius (unit : km)
R = 6378.137;
%--------------------------------------------------------------------------
disp(' --- Generate FVCOM grid and boundary')
% Read FVCOM grid
if contains(fgrid, '.grd')
    [x, y, nv] = read_2dm(fgrid);
    f = f_load_grid(x, y, nv);
elseif contains(fgrid, '.2dm')
    [x, y, nv] = read_2dm(fgrid);
    f = f_load_grid(x, y, nv);
elseif contains(fgrid, '.nc')
    f = f_load_grid(fgrid);
end

% Generate the grid
[x_grid, y_grid, cos_c] = geo2ortho(lon0, lat0, f.x, f.y);
k = cos_c<0;
x_grid(k) = nan;
y_grid(k) = nan;
% Generate the grid boundary
for i = 1 : length(f.bdy_x)
    [x_bdy{i}, y_bdy{i}] = geo2ortho(lon0, lat0, f.bdy_x{i}, f.bdy_y{i});
end


disp(' --- Generate coastline (This may take several minutes)')
% Generate the coastline 
data = gshhs(fcoast);
lon_coast = [data.Lon]';
lat_coast = [data.Lat]';
[x, y] = geo2ortho(lon0, lat0, lon_coast, lat_coast);
coast = polyshape(x, y);
% The method below is more compicated and time consuming.
% x = [];
% y = [];
% for i = 1 : length(data)
%     [x0, y0, cos_c] = geo2ortho(lon0, lat0, data(i).Lon, data(i).Lat);
%     percent = sum(cos_c>=0) / length(cos_c);
%     if percent>0.3
%         x = [x x0];
%         y = [y y0];
%     end
% end
% coast = polyshape(x, y);


disp(' --- Generate mask')
% Generate the mask
mask_out = [-R R R -R; -R -R R R]';
theta = 0: 0.1: pi*2;
mask_in = R* [cos(theta); sin(theta)]';
mask = polyshape({mask_out(:,1), mask_in(:,1)}, {mask_out(:,2), mask_in(:,2)});


disp(' --- Generate lines')
% Generate the lines
if exist('lines', 'var')
    for i = 1 : length(lines)
        [x_lines{i}, y_lines{i}] = geo2ortho(lon0, lat0, lines(i).line(1,:), lines(i).line(2,:));
    end
end

%--------------------------------------------------------------------------
disp(' --- Draw figure')
figure
hold on
% Plot FVCOM grid
patch('Vertices',[x_grid,y_grid], 'Faces',nv, ...
      'FaceColor','w', 'FaceAlpha',1, ...
      'EdgeColor',color_grid, 'LineWidth',0.1);
% Plot FVCOM land
for i = 1 : length(x_bdy)
    patch(x_bdy{i}(1:end-1), y_bdy{i}(1:end-1), color_land, ...
          'EdgeColor', color_grid, 'LineWidth', 0.1);
end
% Plot GSHHS land
plot(coast, 'FaceAlpha', 1, 'FaceColor', color_land, ...
     'EdgeColor', 'k', 'LineWidth', 0.1);
if exist('x_lines', 'var')
    for i = 1 : length(x_lines)
        color = color_lines;
        linewidth = 0.2;
        linestyle = '-';
        if isfield(lines(i), 'color') 
            if ~isempty(lines(i).color)
                color = lines(i).color;
            end
        end
        if isfield(lines(i), 'linewidth')
            if ~isempty(lines(i).linewidth)
                linewidth = lines(i).linewidth;
            end
        end
        if isfield(lines(i), 'linestyle')
            if ~isempty(lines(i).linestyle)
                linestyle = lines(i).linestyle;
            end
        end
        plot(x_lines{i}, y_lines{i}, 'color', color, ...
             'linewidth', linewidth, 'linestyle', linestyle)
    end
end
plot(mask, 'EdgeColor', 'w', ...
           'FaceAlpha', 1, 'FaceColor', 'w');
axis equal
axis off
axis([-R R -R R])
set(gcf, 'position', [1776 2 885 781])

disp(' --- Save figure file')
exportgraphics(gcf, ffig,'Resolution',300);
% mf_save(ffig)