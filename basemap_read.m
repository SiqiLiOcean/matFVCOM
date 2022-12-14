%==========================================================================
% Read basemap
%
% input  :
%   xlims0 --- longitude range
%   ylims0 --- latitude range
%   Basemap --- optional (degfault)
% 
% output :
%   bm.xlims
%   bm.ylims
%   bm.A
%
% Siqi Li, SMAST
% 2022-04-05
%
% Updates:
%
%==========================================================================
function bm = basemap_read(xlims0, ylims0, varargin)

% clc
% clear

% bmap =  geobasemap('satellite');

varargin = read_varargin(varargin, {'Basemap'}, {'satellite'});
varargin = read_varargin2(varargin, {'Grid'});



ftmp = './tmp-379826.png';

% xlims0 = [-80 -60];
% ylims0 = [27 47];
dx = diff(xlims0);
dy = diff(ylims0);
xlims = [xlims0(1)-dx*0.05 xlims0(2)+dx*0.05];
ylims = [ylims0(1)-dy*0.05 ylims0(2)+dy*0.05];
% xlims = [0 45];
% ylims = [44 89];



figure('visible', 'off')
gx = geoaxes;
% gx.Position = [0 0 1 1];
hold on
% geoplot([30 30], [-80 -60], 'w-', 'linewidth', 2)
% geoplot([50 50], [-80 -60], 'w-', 'linewidth', 2)
% geoplot([30 50], [-80 -80], 'w-', 'linewidth', 2)
% geoplot([30 50], [-60 -60], 'w-', 'linewidth', 2)
% % % gx.LatitudeAxis.Visible='off';
% % % gx.LatitudeLabel.Visible = 'off';
% % % gx.LongitudeAxis.Visible='off';
% % % gx.LongitudeLabel.Visible = 'off';
% % % gx.Scalebar.Visible = 'off';
gx.Basemap = 'satellite';
% gx.OuterPosition = [0 0 1 1];
% gx.InnerPosition = [0 0 1 1];
gx.Grid = 'off';
gx.GridColor = [1 1 1];
% gx.LongitudeLimits = [27 47];
% gx.LatitudeLimits = [-80 -60];
geolimits(ylims, xlims)
% gx.Parent.Position = [100 100 800 800];

if ~isempty(Grid)
    gx.Grid = 'on';
end

mf_save(ftmp);
bm.xlims = gx.LongitudeLimits;
bm.ylims = gx.LatitudeLimits;
% bm.xlims = xlims0;
% bm.ylims = ylims0;

bm.A = imread(ftmp);
ny = size(bm.A, 1);
nx = size(bm.A, 2);

lon1 = bm.xlims(1);
lon2 = bm.xlims(2);
lat1 = bm.ylims(1);
lat2 = bm.ylims(2);
% [x1, y1] = proj_geo2miller(lon1, lat1);
% [x2, y2] = proj_geo2miller(lon2, lat2);
% tmp_x = linspace(x1, x2, nx);
% tmp_y = linspace(y2, y1, ny);
% [bm.x, ~] = proj_miller2geo(tmp_x, 0*tmp_x);
% [~, bm.y] = proj_miller2geo(0*tmp_y, tmp_y);
[x1, y1] = proj_geo2lony(lon1, lat1);
[x2, y2] = proj_geo2lony(lon2, lat2);
tmp_x = linspace(x1, x2, nx);
tmp_y = linspace(y1, y2, ny);
tmp_y = tmp_y(end:-1:1);
bm.x = tmp_x;
[~, bm.y] = proj_lony2geo(0*tmp_y, tmp_y);



s = wgs84Ellipsoid;
bm.x2 = geocentricLatitude(bm.x, s.Flattening);


close
% % % delete(ftmp);

