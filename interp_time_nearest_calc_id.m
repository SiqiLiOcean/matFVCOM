%==========================================================================
%
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% 2021-11-25
%
% Updates:
%
%==========================================================================
function [k1, k2] = interp_time_nearest_calc_id(t1, t2, varargin)

varargin = read_varargin(varargin, {'Window'}, {15/60/24});

t1 = t1(:);
t2 = t2(:);

[k1, d] = ksearch([t1 zeros(length(t1),1)], [t2 zeros(length(t2),1)]);

k2 = find(d>Window);