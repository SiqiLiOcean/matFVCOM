%==========================================================================
% Calculate the cell center in spherical coordinate
%
% input  :
%   lon --- longitude (degree), (node, 3)
%   lat --- latitude (degree), (node, 3)
%   nv  ---
%   'Global'
% 
% output :
%   lonc ---
%   latc ---
%
% Siqi Li, SMAST
% 2022-12-15
%
% Updates:
%
%==========================================================================
function [lonc, latc] = calc_xcyc(lon, lat, nv, varargin)

varargin = read_varargin2(varargin, {'Global'});

if ~isempty(Global)
    r = 90.0 - lat(nv);
    theta = lon(nv);
    x = r .* cosd(theta);
    y = r .* sind(theta);

    xc = mean(x, 2);
    yc = mean(y, 2);
    rc = sqrt(xc.^2 + yc.^2);
    thetac = atan2d(yc, xc);
    lonc = thetac;
    latc = 90 - rc;
else
    lonc = mean(lon(nv), 2);
    latc = mean(lat(nv), 2);
end