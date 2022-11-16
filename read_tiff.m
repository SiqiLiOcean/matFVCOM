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
function [xx, yy, zz] = read_tiff(fin)

% Read the tiff file
[zz,R] = readgeoraster(fin);

% Read the dimension information
disp(R.CoordinateSystemType)
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

