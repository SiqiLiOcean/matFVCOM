%==========================================================================
% Change the longitude to the same range as the other
% 
%
% input  :
%   lon1 ---
%   lon2 ---
% 
% output :
%   lon2 ---
%
% Siqi Li, SMAST
% 2023-01-04
%
% Updates:
%
%==========================================================================
function lon2 = calc_lon_same(lon1, lon2)


lon1_lims = minmax(lon1);
lon2_lims = minmax(lon2);


if lon1_lims(2)>180 && lon2_lims(1)<0 
    lon2 = calc_lon_360(lon2);
elseif lon1_lims(1)<0 && lon2_lims(2)>180
    lon2 = calc_lon_180(lon2);
end