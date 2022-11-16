%==========================================================================
% Convert UTM (x, y) to Geo-referenced Coordinate (lon, lat) 
%   in WGS84
%
% input  : 
%   x   --- x in UTM
%   y   --- y in UTM
%   zone--- UTM zone
%
% output :
%   lon --- longitude
%   lat --- latitude
%
% Siqi Li, SMAST
% 2022-10-16
%
% Updates:
%
%==========================================================================
function [lon, lat] = proj_utm2geo(x, y, zone)

% Create the utmstruct
utmstruct = defaultm('utm');
utmstruct.zone = zone;
utmstruct.geoid = almanac('earth', 'wgs84', 'meters');
utmstruct = defaultm(utmstruct);

% Do the projection
[lat, lon] = projinv(utmstruct, x, y);

