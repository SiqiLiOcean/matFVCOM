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
function [lon, lat] = proj_mercator2geo(x, y, varargin)

varargin = read_varargin(varargin, {'Lon0'}, {0});

y_rad = y / 180 * pi;
lon = x + Lon0;


lat_rad = atan(sinh(y_rad));

lat = lat_rad / pi * 180;