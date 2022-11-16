%==========================================================================
% Convert the data to a certain range
%
% input  :
%   data0 --- the original data
%   lim1  --- the lower boundary
%   lim2  --- the upper boundary
% 
% output :
%   data --- the output in the range [lim1, lim2]
%
% Usage:
%   1. Convert the wind direction data to [0, 360]
%      wdir = calc_convert_range(wdir0, 0, 360);
%   2. Convert the longtitude to [-180, 180]
%      lon = calc_convert_range(lon0, -180, 180);
%   3. Convert the longtitude to [0, 360]
%      lon = calc_convert_range(lon0, 0, 360);
%
% Siqi Li, SMAST
% 2022-05-04
%
% Updates:
%
%==========================================================================
function data = calc_convert_range(data0, lim1, lim2)


data = mod(data0 - lim1, (lim2-lim1)) + lim1;