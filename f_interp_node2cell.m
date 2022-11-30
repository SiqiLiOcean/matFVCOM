function var2 = f_interp_node2cell(fgrid, var1)

node = fgrid.node;
nele = fgrid.nele;
nv = fgrid.nv;

dims1 = size(var1);

% Find the dimension of node
dim_interp = find(dims1==node);

if dim_interp~=1
    error('The size of input var1 is wrong.')
end

dims2 = dims1;
dims2(dim_interp) = nele;


v1 = reshape(var1, node, []);

v2 = (v1(nv(:,1),:) + v1(nv(:,2),:) + v1(nv(:,3),:)) / 3;

var2 = reshape(v2, dims2);

