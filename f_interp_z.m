%==========================================================================
% Interpolate FVCOM 3d data to scatted depths.
%
% input  :
%   fgrid --- fvcom grid
%   var0  --- data on fvcom grid (node/nele, nsiglay/nsiglev, ...)
%   zo    --- destination depths (nz)
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
function var_out = f_interp_z(fgrid, var0, zo)

dims = size(var0, 1:3);


if dims(2) == fgrid.kbm1
    z = fgrid.deplay;
elseif dims(2) == fgrid.kb
    z = fgrid.deplev;
else
    error('The 2nd dimension length is not right')
end


weight_v = interp_vertical_calc_weight(z, repmat(zo(:)',dims(1),1));

for it = 1 : dims(3)
    var_out(:,:,it) = interp_vertical_via_weight(var0(:,:,it), weight_v);
end

