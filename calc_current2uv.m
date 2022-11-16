%==========================================================================
% Calculate wind u, v from current/wave speed and direction
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
function [u, v] = calc_current2uv(spd, dir)

u = spd .* cosd(dir);
v = spd .* sind(dir);

