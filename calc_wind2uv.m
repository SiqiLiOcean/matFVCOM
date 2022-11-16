%==========================================================================
% Calculate wind u, v from wind speed and direction
%
% input  : 
%   --- spd
%   --- dir
%
% output :
%   --- u
%   --- v
% 
% Siqi Li, SMAST
% 2021-07-01
%
% Updates:
%
%==========================================================================
function [u, v] = calc_wind2uv(spd, dir)

u = spd .* cosd(270-dir);
v = spd .* sind(270-dir);

