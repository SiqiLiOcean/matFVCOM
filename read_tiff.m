%==========================================================================
% Read tiff file
%
% input  : 
%   fin --- tiff input file.
% 
% output :
%   xx --- 2-d longitude
%   yy --- 2-d latitude
%   zz --- 2-d bathymetry
%
% Siqi Li, SMAST
% 2022-01-10
%
% Updates:
%
%==========================================================================
function [xx, yy, zz] = read_tiff(fin, varargin)

varargin = read_varargin2(varargin, {'Increase'});

% Read the tiff file
[zz,R] = readgeoraster(fin);

% Read the dimension information
% disp(R.CoordinateSystemType)
switch R.CoordinateSystemType
    case 'geographic'
        xlims = R.LongitudeLimits;
        ylims = R.LatitudeLimits;
    case 'planar'
        xlims = R.XWorldLimits;
        ylims = R.YWorldLimits;
    otherwise
        error(['Unknown CoordinateSystemType: ' R.CoordinateSystemType])
end


nx = R.RasterSize(2);
ny = R.RasterSize(1);
%
x = linspace(xlims(1), xlims(2), nx);
y = linspace(ylims(2), ylims(1), ny);

% 2-d longitude and latitude
[yy, xx] = meshgrid(y, x);
% 2-d depth
zz = double(zz');

if ~isempty(Increase)
    if x(1) > x(end)
        xx = flipud(xx);
        yy = flipud(yy);
        zz = flipud(zz);
    end
    if y(1) > y(end)
        xx = fliplr(xx);
        yy = fliplr(yy);
        zz = fliplr(zz);
    end
end