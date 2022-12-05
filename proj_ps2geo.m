%==========================================================================
% Convert Polar Stereographic Coordinate (x, y) in WGS84 to Geo-referenced 
% Coordinate (lon, lat)
%
% input  : 
%   x   --- x in Polar Stereographic Coordinate / R
%   y   --- y in Polar Stereographic Coordinate / nan
%   'Long'  --- the center bottom longitude
%   'South' --- Centered at south pole if presented
%
% output :
%   lon     --- longitude
%   lat     --- latitude
%
% usage:
%   1. [lon, lat] = proj_ps2geo(x, y, varargin)
%   2. lat = proj_ps2geo(nan, 1e5);
%
% Siqi Li, SMAST
% 2022-11-19
%
% Updates:
%
%==========================================================================
function [lon, lat] = proj_ps2geo(x, y, varargin)

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
if isnan(x)
    [lat, lon] = projinv(PSstruct, 0, y);
    lon = lat;
    lat = lon*nan;
else
    [lat, lon] = projinv(PSstruct, x, y);
end
