%==========================================================================
% Calculate the hurricane center location and slp based on slp
%
% input  :
%   lon  --- longitude, (nx, ny)
%   lat  --- latitude, (nx, ny)
%   slp  --- sea level pressure, (nx, ny, nt)
% 
% output :
%
% Siqi Li, SMAST
% 2021-12-09
%
% Updates:
%
%==========================================================================
function [c_lon, c_lat, c_slp, c_ix, c_iy] = calc_tc_center(lon, lat, slp)

nt = size(slp, 3);


for it = 1 : nt
    
    c_slp(it) = min(min(slp(:,:,it)));
    
    [c_ix(it), c_iy(it)] = find(slp(:,:,it)==c_slp(it), 1);
    
    c_lon(it) = lon(c_ix(it), c_iy(it));
    c_lat(it) = lat(c_ix(it), c_iy(it));
    
end 
    
    
end