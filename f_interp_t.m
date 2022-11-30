%==========================================================================
% Interpolate FVCOM 3d data to scatted times.
%
% input  :
%   time0 --- source times (nt0)
%   var0  --- data on fvcom grid (node/nele, (nsiglay/nsiglev), nt0)
%   to    --- destination times (nt)
% 
% output :
%   var_out --- data interpolated on destination point (node/nele, nz)
%
% Siqi Li, SMAST
% 2022-11-07
%
% Updates:
%
%==========================================================================
function var_out = f_interp_t(time0, var0, to)


weight_t = interp_time_calc_weight(time0, to);

[var1, dims1] = dims_tar(var0, 4);

for i = 1 : size(var1, 1)
    var2(i,:) = interp_time_via_weight(var1(i,:), weight_t);
end

var_out = dims_untar(var2, dims1, 4);