%==========================================================================
%
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% yyyy-mm-dd
%
% Updates:
%
%==========================================================================
function [miu, sigma] = f_calc_statistic(fgrid, v, varargin)


varargin = read_varargin(varargin, {'R'}, {6371e3});
varargin = read_varargin2(varargin, {'Geo'});

x = fgrid.x;
y = fgrid.y;
nv = fgrid.nv;
node = fgrid.node;
nele =  fgrid.nele;



S = calc_area(x(nv), y(nv), 'R', R, Geo);
% make S smaller
S = S / min(S);

S_sum = sum(S);


if length(v) == node
    vc = f_interp_node2cell(fgrid, v);
else
    vc = v;
end



[vc, dims] = dims_tar(vc, 1);

miu = vc' * S ./ S_sum;
miu = miu';

square_error = (vc - repmat(miu, nele, 1)).^2;
sigma = sqrt( square_error' * S / S_sum);
sigma = sigma';

miu = dims_untar(miu, dims, 1);
sigma = dims_untar(sigma, dims, 1);

end