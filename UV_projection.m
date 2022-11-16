%==========================================================================
% UV Projection: Convert FVCOM UV from Cartisian Coordinate to Geographic
%                Coordinate
%
% This code was modified based on the python code of Vitalii Sheremet,
%   WHOI.
%
% input  : x   --- node x in Cartisian Coordinate (node, 1)
%          y   --- node y in Cartisian Coordinate (node, 1)
%          nv  --- node id of each cell           (nele, 3)
%          lon --- node longitude                 (node, 1)
%          lat --- node latitude                  (node, 1)
%          u   --- cell u in Cartisian Coordinate (first dimension is nele)
%          v   --- cell v in Cartisian Coordinate (first dimension is nele)
% 
% output : uE  --- cell u in Geographic Coordinate (nele, 1)
%          vN  --- cell v in Geographic Coordinate (nele, 1)
%
% Usage  : 
%   x = ncread(file, 'x');
%   y = ncread(file, 'y');
%   nv = ncread(file, 'nv');
%   lon = ncread(file, 'lon');
%   lat = ncread(file, 'lat');
%   u = ncread(file, 'u');
%   v = ncread(file, 'v');
%   [uE, vN] = UV_projection(x, y, nv, lon, lat, u, v);
%
% Siqi Li, SMAST
% 2021-06-14
%
%==========================================================================
function [uE, vN] = UV_projection(x, y, nv, lon, lat, u, v)


% Get the dimensions of inputs
node = length(x);
nele = size(nv, 1);
dims = size(u);

if length(y)~=node || length(lon)~=node || length(lat)~=node
    error('Check the size of x, y, lon, lat')
end

if dims(1)~=nele
    error('The first dimension of u and v has to be NELE')
end


% latitude at cell center
latc = mean(lat(nv), 2);

% Earth radius (m)
a = 6371000;


%  Lame coefficients for the spherical coordinates
C = cosd(latc);



% Location information of each node in cell
x1 = x(nv(:,1));
x2 = x(nv(:,2));
x3 = x(nv(:,3));
y1 = y(nv(:,1));
y2 = y(nv(:,2));
y3 = y(nv(:,3));
lon1 = lon(nv(:,1));
lon2 = lon(nv(:,2));
lon3 = lon(nv(:,3));
lat1 = lat(nv(:,1));
lat2 = lat(nv(:,2));
lat3 = lat(nv(:,3));

% Cell area * 2 (cross-product)
A = ( (x2-x1) .* (y3-y1) - (x3-x1) .* (y2-y1) );

% parameters
aclon_x =  a * C .* ((lon2-lon1).*(y3-y1) - (lon3-lon1).*(y2-y1)) ./ A *pi/180; 
aclon_y = -a * C .* ((lon2-lon1).*(x3-x1) - (lon3-lon1).*(x2-x1)) ./ A *pi/180; 
alat_x  =  a     .* ((lat2-lat1).*(y3-y1) - (lat3-lat1).*(y2-y1)) ./ A *pi/180; 
alat_y  = -a     .* ((lat2-lat1).*(x3-x1) - (lat3-lat1).*(x2-x1)) ./ A *pi/180; 



% Projection
u_l = reshape(u, nele, []);
v_l = reshape(v, nele, []);
dims2 = size(u_l);
for i = 1 :dims2(2)
    uE_l(:,i) = aclon_x.*u_l(:,i) + aclon_y.*v_l(:,i);
    vN_l(:,i) =  alat_x.*u_l(:,i) +  alat_y.*v_l(:,i);
end

uE = reshape(uE_l, dims);
vN = reshape(vN_l, dims);

