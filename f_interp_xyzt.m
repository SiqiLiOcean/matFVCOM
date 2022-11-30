%==========================================================================
% Interpolate FVCOM 4d data to scatted points and times.
%
% input  :
%   fgrid --- fvcom grid
%   time0 --- time of fvcom data (nt0)
%   var0  --- data on fvcom grid (node/nele, nsiglay/nsiglev, nt0)
%   xo    --- destination x (1)
%   yo    --- destination y (1)
%   zo    --- destination depths (nz)
%   to    --- destination times (nt)
% 
% output :
%   var_out --- data interpolated on destination point (nz, nt)
%
% Siqi Li, SMAST
% 2022-11-07
%
% Updates:
%
%==========================================================================
function var_out = f_interp_xyzt(fgrid, time0, var0, xo, yo, zo, to)

var1 = f_interp_xyz(fgrid, var0, xo, yo, zo);

var_out = f_interp_t(time0, var1, to);

% weight_t = interp_time_calc_weight(time0, to);
% 
% nz = length(zo);
% nt = length(to);
% 
% var_out = nan(nz, nt);
% for iz = 1 : nz
%     var_out(iz, :) = interp_time_via_weight(var1(iz,:), weight_t);
% end
% 
