%==========================================================================
% Calculate the hurricane center location and slp based on slp
%   with the wind-adjustment 
%
% input  :
%   lon  --- longitude, (nx, ny)
%   lat  --- latitude, (nx, ny)
%   slp  --- sea level pressure, (nx, ny, nt)
%   wspd --- 10-m wind speed (nx, ny, nt)
% 
% output :
%
% Siqi Li, SMAST
% 2022-01-18
%
% Updates:
%
%==========================================================================
function [c_lon, c_lat, c_slp, c_ix, c_iy] = calc_tc_center2(lon, lat, slp, wspd, varargin)

if isempty(varargin)
    nn = 10;
else
    nn = varargin{1};
end

nx = size(slp, 1);
ny = size(slp, 2);
nt = size(slp, 3);


for it = 1 : nt

    
    min_slp = min(min(slp(:,:,it)));
    
    [ix, iy] = find(slp(:,:,it)==min_slp, 1);
    
    ix1 = max(ix-nn, 1);
    iy1 = max(iy-nn, 1);
    ix2 = min(ix+nn, nx);
    iy2 = min(iy+nn, ny);
        
    
    wspd_it = nan(nx, ny);
    wspd_it(ix1:ix2, iy1:iy2) = wspd(ix1:ix2, iy1:iy2);
    
    min_wspd = nanmin(wspd_it(:));
    
    [ix, iy] = find(wspd_it==min_wspd, 1);
    
    c_ix(it) = ix;
    c_iy(it) = iy;
    c_lon(it) = lon(ix, iy);
    c_lat(it) = lat(ix, iy);
%     c_slp(it) = slp(ix, iy, it);
    c_slp(it) = min_slp;
    
%     c_slp(it) = min(min(slp(:,:,it)));
%     
%     [c_ix(it), c_iy(it)] = find(slp(:,:,it)==c_slp(it), 1);
%     
%     c_lon(it) = lon(c_ix(it), c_iy(it));
%     c_lat(it) = lat(c_ix(it), c_iy(it));
    
end 
    
    
end