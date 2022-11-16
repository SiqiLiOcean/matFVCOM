%==========================================================================
% Orthographic Projection  
%
% Ref:
% https://en.wikipedia.org/wiki/Orthographic_map_projection
%
% input  : 
%   lon0 --- center longitude
%   lat0 --- center latitude
%   lon  --- input longitude
%   lat  --- input latitude
% 
% output :
%   x     --- output x
%   y     --- output y
%   cos_c --- 
%
% Siqi Li, SMAST
% 2021-06-28
%
% Updates:
%
%==========================================================================
function [x, y, cos_c] = geo2ortho(lon0, lat0, lon, lat)

% Earth radius (km)
R = 6378.137;

x = R * cosd(lat) .* sind(lon-lon0);
y = cosd(lat0) * sind(lat) - sind(lat0) * cosd(lat) .* cosd(lon-lon0);
y = R*y;
cos_c = sind(lat0) .* sind(lat) + cosd(lat0) * cosd(lat) .* cosd(lon-lon0);

theta = atan2d(y, x);

% The point should be clipped from the map if cos(c) is negative.
k = find(cos_c<0); 
x(k) = 2 * R * cosd(theta(k)) - x(k);
y(k) = 2 * R * sind(theta(k)) - y(k);


end