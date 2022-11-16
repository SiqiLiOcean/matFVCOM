%==========================================================================
% 
% input  : 
% 
% output :
%
% Siqi Li, SMAST
% 2021-06-24
%
% Updates:
%
%==========================================================================
function [h1, h2] = f_2d_lonlat(fgrid, varargin)

if isempty(get(gcf,'Children'))
    error('Draw the axes first')
end

varargin = read_varargin(varargin, {'Stride', 'Style'}, {1, 1});

% Parameters.
npixel = 200;

x = fgrid.x;
y = fgrid.y;
lon = fgrid.LON;
lat = fgrid.LAT;


xlims = get(gca, 'xlim');
ylims = get(gca, 'ylim');



[yy, xx] = meshgrid(linspace(ylims(1),ylims(2),npixel), linspace(xlims(1),xlims(2),npixel));
% 
% F1 = scatteredInterpolant(x, y, lon);
% F2 = scatteredInterpolant(x, y, lat);
% grid_lon = F1(xx, yy);
% grid_lat = F2(xx, yy);
grid_lon = fgrid.proj.xy2lon(xx, yy);
grid_lat = fgrid.proj.xy2lat(xx, yy);

xaxis = [linspace(xlims(1),xlims(2),npixel)' repmat(ylims(1),npixel,1)];
yaxis = [repmat(xlims(1),npixel,1) linspace(ylims(1),ylims(2),npixel)'];

lon_xaxis = fgrid.proj.xy2lon(xaxis(:,1), xaxis(:,2));
lat_yaxis = fgrid.proj.xy2lat(yaxis(:,1), yaxis(:,2));

% num_xaxis0 = union(floor(lon_xaxis), ceil(lon_xaxis));
% num_yaxis0 = union(floor(lat_yaxis), ceil(lat_yaxis));
num_xaxis0 = union(floor(grid_lon), ceil(grid_lon));
num_yaxis0 = union(floor(grid_lat), ceil(grid_lat));
num_lon = num_xaxis0(1) : Stride : num_xaxis0(end);
num_lat = num_yaxis0(1) : Stride : num_yaxis0(end);
num_xaxis = num_lon(num_lon>=lon_xaxis(1) & num_lon<=lon_xaxis(end));
num_yaxis = num_lat(num_lat>=lat_yaxis(1) & num_lat<=lat_yaxis(end));



% XTickLabel = num2str(num_xaxis(:));
% YTickLabel = num2str(num_yaxis(:));

% Style list (Take -72.5 degree as an example)
%       1       2       3       4       5       6
%    72.5   -72.5   72.5W   72.5*  -72.5*  72.5*W

n_xtick = length(num_xaxis);
n_ytick = length(num_yaxis);

switch Style
    case 1
        XTickLabel = num2str(abs(num_xaxis(:)));
        YTickLabel = num2str(abs(num_yaxis(:)));
    case 2
        XTickLabel = num2str(num_xaxis(:));
        YTickLabel = num2str(num_yaxis(:));
    case 3
        E = repmat('E', n_xtick, 1);
        E(num_xaxis<0) = 'W';
        E(num_xaxis==0) = ' ';
        N = repmat('N', n_ytick, 1);
        N(num_yaxis<0) = 'S';
        N(num_yaxis==0) = ' ';
        XTickLabel = [num2str(abs(num_xaxis(:))) E];
        YTickLabel = [num2str(abs(num_yaxis(:))) N];
    case 4
        XTickLabel = [num2str(abs(num_xaxis(:))) repmat('^o', n_xtick, 1)];
        YTickLabel = [num2str(abs(num_yaxis(:))) repmat('^o', n_ytick, 1)];
    case 5
        XTickLabel = [num2str(num_xaxis(:)) repmat('^o', n_xtick, 1)];
        YTickLabel = [num2str(num_yaxis(:)) repmat('^o', n_ytick, 1)];
    case 6
        E = repmat('^oE', n_xtick, 1);
        E(num_xaxis<0,3) = 'W';
        E(num_xaxis==0,3) = ' ';
        N = repmat('^oN', n_ytick, 1);
        N(num_yaxis<0,3) = 'S';
        N(num_yaxis==0,3) = ' ';
        XTickLabel = [num2str(abs(num_xaxis(:))) E];
        YTickLabel = [num2str(abs(num_yaxis(:))) N];    
    otherwise
        error('Unkown Style')
end


XTick = interp1(lon_xaxis, xaxis(:,1), num_xaxis);
YTick = interp1(lat_yaxis, yaxis(:,2), num_yaxis);

set(gca, 'XTick', XTick)
set(gca, 'XTickLabel', XTickLabel)
set(gca, 'YTick', YTick)
set(gca, 'YTickLabel', YTickLabel)



[~, h1] = contour(xx, yy, grid_lon, num_lon);
[~, h2] = contour(xx, yy, grid_lat, num_lat);

set(h1, 'LineWidth', 0.5, 'Color', [.8 .8 .8])
set(h2, 'LineWidth', 0.5, 'Color', [.8 .8 .8])


if ~isempty(varargin)
    set(h1, varargin{:})
    set(h2, varargin{:})
end


end
