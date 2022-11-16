%==========================================================================
% Calculate the maximum wind, radius of maximum wind, and the location,
% based on wind speed and sea level pressure 
%
% input  :
%   lon  --- longitude, (nx, ny)
%   lat  --- latitude, (nx, ny)
%   spd  --- wind speed, (nx, ny, nt)
%   slp  --- sea level pressure, (nx, ny, nt)
% 
% output :
%   mw     --- maximum wind (m/s)
%   rmw    --- Radius of maximum wind (km)
%   mw_lon --- longitude of maximum wind
%   mw_lat --- latitude of maximum wind
%
% Siqi Li, SMAST
% 2021-12-09
%
% Updates:
%
%==========================================================================
function [mw, rmw, mw_lon, mw_lat] = calc_tc_mw(lon, lat, spd, slp, varargin)

varargin = read_varargin(varargin, {'Rmax'}, {250});


nt = size(spd, 3);





[c_lon, c_lat] = calc_tc_center(lon, lat, slp);



for it = 1 : nt
    
    spd_tmp = spd(:,:,it);
    distance = calc_distance(lon, lat, c_lon(it), c_lat(it), 'Geo') / 1000;
    spd_tmp(distance>Rmax) = nan;
    
    
    mw(it) = nanmax(spd_tmp(:));
    
    [mw_ix(it), mw_iy(it)] = find(spd_tmp==mw(it));

    mw_lon(it) = lon(mw_ix(it), mw_iy(it));
    mw_lat(it) = lat(mw_ix(it), mw_iy(it));    
    
    
    rmw(it) = calc_distance(mw_lon(it), mw_lat(it), c_lon(it), c_lat(it), 'Geo') / 1000;
end
