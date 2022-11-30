function var2 = f_interp_level2layer(fgrid, var1)


kb = fgrid.kb;
kbm1 = fgrid.kbm1;


dims1 = size(var1);

% Find the dimension of node
dim_interp = find(dims1==kb);
if length(dim_interp)>1
    disp('There are more than one dimensions that has the same length as kb.')
    disp('Use the first one.')
    dim_interp = dim_interp(1);
end

if isempty(dim_interp)
    error('The size of input var1 is wrong.')
end

% if length(dim_interp)>1
%     error('There are two dimensions with the length of kb.')
% end

dims2 = dims1;
dims2(dim_interp) = kbm1;

dimorder_forward = 1:length(dims1);
dimorder_forward(dim_interp) = [];
dimorder_forward = [dim_interp dimorder_forward];

[~, dimorder_backward] = sort(dimorder_forward);

v1 = permute(var1, dimorder_forward);
v1 = reshape(v1, kb, []);

v2 = (v1(1:kb-1,:) + v1(2:kb,:)) /2;
v2 = reshape(v2, dims2(dimorder_forward));
var2 = permute(v2, dimorder_backward);


