%==========================================================================
% Interpolate FVCOM 3d data to scatted points.
%
% input  :
%   fgrid --- fvcom grid
%   var0  --- data on fvcom grid (the 1st dimension should be node/nele)
%   xo    --- destination x (1)
%   yo    --- destination y (1)
% 
% output :
%   var_out --- data interpolated on destination point (nz, nt) or (nz) or (nt)
%
% Siqi Li, SMAST
% 2022-11-07
%
% Updates:
%
%==========================================================================
function var_out = f_interp_xy(fgrid, var0, xo, yo)

dims = size(var0);

if dims(1) == fgrid.node
    x = fgrid.x;
    y = fgrid.y;
elseif dims(1) == fgrid.nele
    x = fgrid.xc;
    y = fgrid.yc;
else
    error('The first dimension length is not right.')
end
nv = fgrid.nv;


weight_h = interp_2d_calc_weight('TRI', x, y, nv, xo, yo, 'Extrap');
id = weight_h.id;
w = weight_h.w;

var1 = var0(id, :, :);

[var2, dims_out] = dims_tar(var1, 1);

var3 = var2' * w(:);
var3 = var3';
% for i = 1 : size(var2)
%     % Interpolate horizontal
%     var3(:,i) = var2' * w';
% end

var_out = reshape(var3, dims_out(2:end));
% var_out = squeeze(dims_untar(var3, dims_out, 1));



