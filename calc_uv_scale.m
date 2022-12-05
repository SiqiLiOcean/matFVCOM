%==========================================================================
% Scale the vector (u, v) in a non-linear way
%   (u, v) = (u, v) / speed;
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% 2022-11-17
%
% Updates:
%
%==========================================================================
function [us, vs] = calc_uv_scale(u, v)

spd = calc_uv2current(u, v);

us = u ./ sqrt(spd);
vs = v ./ sqrt(spd);
