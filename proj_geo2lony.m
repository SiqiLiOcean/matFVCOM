%==========================================================================
% Project (lon, lat) to (x, y)
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
function [x, y] = proj_geo2lony(lon, lat)

x = lon;
y = lat ./ cosd(lat);