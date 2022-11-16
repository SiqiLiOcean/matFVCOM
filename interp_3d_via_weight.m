%==========================================================================
% 3-D Interpolation
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% 2022-09-28
%
% Updates:
%
%==========================================================================
function var2 = interp_3d_via_weight(var1, weight, varargin)

n1 = size(weight.v1.id1, 1);
n2 = size(weight.v2.id1, 1);
varargin = read_varargin(varargin, {'List1'}, {1:n1});
varargin = read_varargin(varargin, {'List2'}, {1:n2});


% 2d horizontal interpolation from fgrid1 to fgrid2
var_std = interp_vertical_via_weight(var1, weight.v1, 'List', List1);

% vertical interpolation from fgrid1 sigma to standard depth 
var_std_hori = interp_2d_via_weight(var_std, weight.h, varargin{:});

% vertical interpolation from standard depth to fgrid2 sigma
var2 = interp_vertical_via_weight(var_std_hori, weight.v2, 'List', List2);

