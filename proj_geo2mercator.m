%==========================================================================
%
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% 2022-12-13
%
% Updates:
%
%==========================================================================
function [x, y] = proj_geo2mercator(lon, lat, varargin)

varargin = read_varargin(varargin, {'Lon0'}, {0});

x = lon - Lon0;
% y = log(tand(lat) + secd(lat));
y_rad = 0.5 * log( (1+sind(lat)) ./ (1-sind(lat)) );

y = y_rad / pi * 180;
