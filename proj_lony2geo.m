%==========================================================================
% Project (x, y) to (lon, lat)
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% 2022-12-12
%
% Updates:
%
%==========================================================================
function [lon, lat] = proj_lony2geo(x, y)

lon = x;

data_lat = 0 : 1e-6 : 70;
data_y = data_lat ./ cosd(data_lat);

lat = sign(y) .* interp1(data_y, data_lat, abs(y));
