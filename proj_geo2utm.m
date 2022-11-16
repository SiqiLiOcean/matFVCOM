%==========================================================================
% Convert Geo-referenced Coordinate (lon, lat) to UTM (x, y)
%   in WGS84
%
% input  : 
%   lon --- longitude
%   lat --- latitude
%
% output :
%   x   --- x in UTM
%   y   --- y in UTM
%   zone--- UTM zone
%
% Siqi Li, SMAST
% 2022-10-16
%
% Updates:
%
%==========================================================================
function [x, y, zone] = proj_geo2utm(lon, lat)

% Find the UTM zone based on (lon, lat)
zone = utmzone([lat, lon]);

% Create the utmstruct
utmstruct = defaultm('utm');
utmstruct.zone = zone;
utmstruct.geoid = almanac('earth', 'wgs84', 'meters');
utmstruct = defaultm(utmstruct);

% Do the projection
[x, y] = projfwd(utmstruct, lat, lon);

