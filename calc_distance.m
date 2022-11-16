%==========================================================================
% Calculate distance between two points in Cartisian Coordinate or
% Geo-referenced Coordinate.
%
% input  :
%   x1
%   y1
%   x2
%   y2
%   'R'      --- earth radius
%   'Geo'
%
% output :
%
% Siqi Li, SMAST
% 2021-10-21
%
% Updates:
%
%==========================================================================
function d = calc_distance(x1, y1, x2, y2, varargin)

varargin = read_varargin(varargin, {'R'}, {6371e3});
varargin = read_varargin2(varargin, {'Geo'});

if Geo
    a = sind(y1).*sind(y2) + cosd(y1).*cosd(y2).*cosd(x1-x2);
    a = max(min(a,1), -1);
    d = R * acos(a);
    
else
    
    d = sqrt((x1-x2).^2 + (y1-y2).^2);
    
end