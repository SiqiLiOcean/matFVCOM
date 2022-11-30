%==========================================================================
% Interpolate FVCOM 3d data to scatted points.
%
% input  :
%   fgrid --- fvcom grid
%   var0  --- data on fvcom grid (node/nele, nsiglay/nsiglev, nt0)
%   xo    --- destination x
%   yo    --- destination y
%   zo    --- destination depths (nz)
% 
% output :
%   var_out --- data interpolated on destination point (node/nele, nz, nt0)
%
% Siqi Li, SMAST
% 2022-11-07
%
% Updates:
%
%==========================================================================
function var_out = f_interp_xyz(fgrid, var0, xo, yo, zo)

% Here we could not simply use f_interp_z and f_interp_xy
% We only interp the related nodes/cells.


dims = size(var0);

if dims(1) == fgrid.node
    x = fgrid.x;
    y = fgrid.y;
    if dims(2) == fgrid.kbm1
        z = fgrid.deplay;
    elseif dims(2) == fgrid.kb
        z = fgrid.deplev;
    else
        error('The second dimension length is not right.')
    end
elseif dims(1) == fgrid.nele
    x = fgrid.xc;
    y = fgrid.yc;
    if dims(2) == fgrid.kbm1
        z = fgrid.deplayc;
    elseif dims(2) == fgrid.kb
        z = fgrid.deplevc;
    else
        error('The second dimension length is not right.')
    end
else
    error('The first dimension length is not right.')
end
nv = fgrid.nv;



nt = size(var0, 3);

weight_h = interp_2d_calc_weight('TRI', x, y, nv, xo, yo, 'Extrap');
id = weight_h.id;
w = weight_h.w;

weight_v = interp_vertical_calc_weight(z(id,:), repmat(zo(:)',3,1));
id1 = weight_v.id1;
id2 = weight_v.id2;
w1 = weight_v.w1;
w2 = weight_v.w2;

var1 = var0(id, :, :);


for it = 1 : nt
    % Interpolate vertically
    var2 = interp_vertical_via_weight(var1(:,:,it), weight_v);
%     for j = 1 : 3
%         var3(j,:,it) = var2(j,id1(j,:)).*w1(j,:) + var2(j,id2(j,:)).*w2(j,:);
%     end
    % Interpolate horizontal
    var_out(:,it) = var2' * w';
end


