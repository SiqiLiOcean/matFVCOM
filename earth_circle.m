%==========================================================================
%   
% input  : 
% 
% output :
%
% Siqi Li, SMAST
% yyyy-mm-dd
%
% Updates:
%
%==========================================================================
function [lon, lat] = earth_circle(clon, clat, d)

R = 6370;
np = 100;

d = d(:);
n = length(d);






for i = 1 : n

dlat_max = d(i)/R *180/pi;
y1 = linspace(clat-dlat_max, clat+dlat_max, np);
dy = y1 - clat;

a = (tan(d(i)/2/R))^2;
a = a/(1+a);

dx = (1-2*a-cosd(dy)+cosd(clat)*cosd(y1)) ./ cosd(clat) ./cosd(y1);
dx  = acosd(dx);
x1 = clon + dx;

y2 = flip(y1(1:np-1));
x2 = clon - flip(dx(1:np-1));

lon(:,i) = [x1 x2];
lat(:,i) =[y1 y2];
end


