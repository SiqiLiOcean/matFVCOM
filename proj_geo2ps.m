%==========================================================================
% Convert Geo-referenced Coordinate (lon, lat) to Polar Stereographic 
% Coordinate (x, y) in WGS84
%
% input  : 
%   lon     --- longitude
%   lat     --- latitude
%   'Long'  --- the center bottom longitude
%   'South' --- Centered at south pole if presented
%
% output :
%   x   --- x in Polar Stereographic Coordinate / R
%   y   --- y in Polar Stereographic Coordinate / nan
%
% usage:
%   1. [x, y] = proj_geo2ps(lon, lat, varargin)
%   2. R = proj_geo2ps(nan, 66);
%
% Siqi Li, SMAST
% 2022-11-19
%
% Updates:
%
%==========================================================================
function [x, y] = proj_geo2ps(lon, lat, varargin)

varargin = read_varargin(varargin, {'Long'}, {0});
varargin = read_varargin2(varargin, {'South'});


% Create the PSstruct
PSstruct = defaultm('stereo');
PSstruct.geoid = almanac('earth', 'wgs84', 'meters');
% Set the center point
if ~isempty(South)
    PSstruct.origin = [-90 Long];
else
    PSstruct.origin = [ 90 Long];
end
PSstruct = defaultm(PSstruct);

% Do the projection
if isnan(lon)
    [y, x] = projfwd(PSstruct, lat, lon);
    x = abs(x);
    y = y*nan;
else
    [x, y] = projfwd(PSstruct, lat, lon);
end
