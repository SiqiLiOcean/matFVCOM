%==========================================================================
% Projection for FVCOM grid: from Geographic Coordinate to Cartesian
%   Coordinate
%
% input  : 
%   fgrid
%   lon
%   lat
% 
% output :
%   x
%   y
% 
% Siqi Li, SMAST
% 2021-06-24
%
% Updates:
%
%==========================================================================
function [x, y] = f_proj_geo2xy(fgrid, lon, lat)

x = fgrid.proj.geo2x(lon, lat);
y = fgrid.proj.geo2y(lon, lat);

end