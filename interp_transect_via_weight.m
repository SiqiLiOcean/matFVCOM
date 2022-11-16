%==========================================================================
% Interpolation for transect plot
%
% Input  : x_in (n_in)
%          y_in (n_in)
%          z_in (n_in,nsigma_in)
%          var_in (n_in,nsigma_in)
%          x (n_out)
%          y (n_out)
%          z (2) [min(depth) max(depth)]
% Output : dd (n_out,nz_out)
%          zz (n_out,nz_out)
%          var_out(n_out,nz_out)
%
% Note : The depth1 and depth2 are all positive, and should be increasing.
%
% Siqi Li, SMAST
% 2020-03-17
%
% Updates:
% 2020-03-18  Siqi Li, Inputs of all the weight related function were 
%                      adjusted. 
%                      func_horizontal_interp_calc_weight_node was removed.
%==========================================================================
function var2 = interp_transect_via_weight(var1, weight)


% ====================Vertical Interpolation to STD====================
var_std = interp_vertical_via_weight(var1, weight.v);

% ====================Horizontal Interpolation====================
var2 = interp_2d_via_weight(var_std, weight.h);




