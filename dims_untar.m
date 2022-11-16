%==========================================================================
%
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% 2022-10-03
%
% Updates:
%
%==========================================================================
function var1 = dims_untar(var2, dims1, mode)

% dims2 = size(var2, 1:4);
dims2(1) = size(var2, 1);
dims2(2) = size(var2, 2);
dims2(3) = size(var2, 3);
dims2(4) = size(var2, 4);


switch mode

    % MODE 1: Keep the first and untar the last dimension back.
    %         e.g. (node, nsiglay*nt) ---> (node, nsiglay, nt)
    case 1
        var1 = reshape(var2, [dims2(1) dims1(2:end)]);
        
    % MODE 2: Untar the first dimension back and untar the 
    %         e.g. (nlon*nlat, nz, nt) ---> (nlon, nlat, nz, nt) 
    case 2 
        var1 = reshape(var2, [dims1(1:2) dims2(2:end)]);
        
    % MODE 3: Untar the first dimension and the second dimension back, seperately 
    %         e.g. (nlon*nlat, nz*nt) ---> (nlon, nlat, nz, nt)
    case 3
        var1 = dims_untar(var2, dims1, 2);
        var1 = dims_untar(var1, dims1, 1);

    % MODE 4: Keep the last dimension and tar the rest.
    %         e.g. (node*nsiglay, nt) ---> (node, nsiglay, nt) 
    %         e.g. (nlon*nlat*nz, nt) ---> (nlon, nlat, nz, nt) 
    case 4
        dims2 = size(var2);
        var1 = reshape(var2, [dims1(1:end-1) dims2(end)]); 

    otherwise
        error('UNKOWN mode.')
        
end


