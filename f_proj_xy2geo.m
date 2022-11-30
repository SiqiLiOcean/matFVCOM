%==========================================================================
% Projection for FVCOM grid: from Cartesian Coordinate to Geographic 
%   Coordinate
%
% input  : 
%   fgrid
%   x
%   y
% 
% output :
%   lon
%   lat
% 
% Siqi Li, SMAST
% 2021-06-24
%
% Updates:
%
%==========================================================================
function [lon, lat] = f_proj_xy2geo(fgrid, x, y)

lon = fgrid.proj.xy2lon(x, y);
lat = fgrid.proj.xy2lat(x, y);

end