%==========================================================================
% Interpolate FVCOM data to certain depth
% input  : 
%   --- fgrid
%   --- var1
%   --- depth
% 
% output :
%   --- var2
%
% Siqi Li, SMAST
% 2021-06-30
%
% Updates:
%
%==========================================================================
function var2 = f_interp_depth(fgrid, var1, depth)

depth = abs(depth);

node = fgrid.node;
nele = fgrid.nele;
kb = fgrid.kb;
kbm1 = fgrid.kbm1;

dims1 = size(squeeze(var1));

if dims1(1)==node && dims1(2)==kbm1
    z = fgrid.deplay;
    h = fgrid.h;
elseif dims1(1)==node && dims1(2)==kb
    z = fgrid.deplev;
    h = fgrid.h;
elseif dims1(1)==nele && dims1(2)==kbm1
    z = fgrid.deplayc;
    h = fgrid.hc;
elseif dims1(1)==nele && dims1(2)==kb
    z = fgrid.deplevc;
    h = fgrid.hc;
else
    error('Wrong input size.')
end

n = dims1(1);
nz = size(z, 2);




weight_v = interp_vertical_calc_weight(z, repmat(depth(:)', n, 1));



if length(dims1)>2
    var1 = reshape(var1, n, nz, []);
end

for i = 1 : size(var1,3) 
    var2(:,:,i) = interp_vertical_via_weight(var1(:,:,i), weight_v);
end

% Remove the points with shallow depth
for i = 1 : length(depth)
    k = h<depth(i);
    var2(k,i,:) = nan;
end

dims2 = dims1;
dims2(2) = length(depth);
if length(dims1)>2
    var2 = reshape(var2, dims2);
end

