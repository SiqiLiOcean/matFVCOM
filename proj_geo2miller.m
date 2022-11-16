%==========================================================================
% Projection: (longitude, latitude) --> (x, y) via Miller projection
%  (https://blog.csdn.net/qq_32693445/article/details/79597213)
% 
% input  :
%   lon --- longitude
%   lat --- latitude
% 
% output :
%   x --- projected x
%   y --- projected y
%
% Siqi Li, SMAST
% 2022-05-18
%
% Updates:
%
%==========================================================================
function [x, y] = proj_geo2miller(lon, lat, varargin)

varargin = read_varargin(varargin, {'R'}, {6371e3});

L = 2 * pi * R;
W = L;
H = L / 2;
mill = 2.3;

lon = lon * pi / 180;
% lat = lat * pi / 180;
lat = -lat * pi / 180;


x1 = lon;
y1 = 1.25 * log( tan(0.25*pi + 0.4*lat) );

x = W/2 + (W / (2*pi)) * x1;
y = H/2 - (H / (2*mill)) * y1; 

