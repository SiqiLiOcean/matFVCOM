%==========================================================================
% Calculate wind speed and direction from u, v
%
% input  : 
%   --- u
%   --- v
%
% output :
%   --- spd
%   --- dir
% 
% Siqi Li, SMAST
% 2021-07-01
%
% Updates:
%
%==========================================================================
function [spd, dir] = calc_uv2wind(u, v)

spd = sqrt(u.^2 +v.^2);

dir = 270 - atan2d(v, u);
dir = mod(dir, 360);
