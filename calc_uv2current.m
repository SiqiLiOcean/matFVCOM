%==========================================================================
% Calculate current/wave speed and direction from u, v
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
function [spd, dir] = calc_uv2current(u, v)

spd = sqrt(u.^2 +v.^2);

dir = atan2d(v, u);

dir = mod(dir, 360.0);
