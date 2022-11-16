%==========================================================================
% Projection: (x, y) --> (longitude, latitude) via Miller projection
%
% input  :
%   x --- projected x
%   y --- projected y
% 
% output :
%   lon --- longitude
%   lat --- latitude
%
% Siqi Li, SMAST
% 2022-05-18
%
% Updates:
%
%==========================================================================
function [lon, lat] = proj_miller2geo(x, y, varargin)

varargin = read_varargin(varargin, {'R'}, {6371e3});

L = 2 * pi * R;
W = L;
H = L / 2;
mill = 2.3;

lat = (H/2-y) * 2 * mill / 1.25 / H;
lat = (atan(exp(lat)) - 0.25*pi) * 180 / 0.4 / pi;

lon = (x - W/2) * 360 / W;

lat = -lat;
