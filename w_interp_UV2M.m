function var2 = w_interp_UV2M(wgrid, var1)

nx = wgrid.nx;
ny = wgrid.ny;

dims1 = size(var1);

var1 = reshape(var1, dims1(1), dims1(2), []);

if dims1(1) == nx+1 && dims1(2) == ny
    % variable on U gridr
    var2 = ( var1(1:nx,:,:) + var1(2:nx+1,:,:) ) / 2;
elseif dims1(1) == nx && dims1(2) == ny+1
    % variable on U grid
    var2 = ( var1(:,1:ny,:) + var1(:,2:ny+1,:) ) / 2;
else
    error('The input var size is not U-grid or V-grid.')
end


var2 = reshape(var2, nx, ny, []);

