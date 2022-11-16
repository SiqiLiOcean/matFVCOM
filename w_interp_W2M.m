function var2 = w_interp_W2M(wgrid, var1)


nz = wgrid.nz;


dims1 = size(var1);

% Find the dimension of node
dim_interp = find(dims1==nz+1);
if length(dim_interp)>1
    disp('There are more than one dimensions that has the same length as H-layer.')
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
dims2(dim_interp) = nz;

dimorder_forward = 1:length(dims1);
dimorder_forward(dim_interp) = [];
dimorder_forward = [dim_interp dimorder_forward];

[~, dimorder_backward] = sort(dimorder_forward);

v1 = permute(var1, dimorder_forward);
v1 = reshape(v1, nz+1, []);

v2 = (v1(1:nz,:) + v1(2:nz+1,:)) /2;
v2 = reshape(v2, dims2(dimorder_forward));
var2 = permute(v2, dimorder_backward);


