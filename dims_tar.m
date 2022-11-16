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
function [var2, dims1] = dims_tar(var1, mode)

% dims1 = size(var1, 1:4);
dims1(1) = size(var1, 1);
dims1(2) = size(var1, 2);
dims1(3) = size(var1, 3);
dims1(4) = size(var1, 4);


switch mode
    
    % MODE 1: Keep the first dimension and tar the rest.
    %         e.g. (node, nsiglay, nt) ---> (node, nsiglay*nt) 
    case 1
        var2 = reshape(var1, dims1(1), []);
        
    % MODE 2: Tar the first two and keep the rest.
    %         e.g. (nlon, nlat, nz, nt) ---> (nlon*nlat, nz, nt)
    case 2 
        var2 = reshape(var1, [dims1(1)*dims1(2), dims1(3:end)]);

    % MODE 3: Tar the first two and the rest dimensions, seperately
    %         e.g. (nlon, nlat, nz, nt) ---> (nlon*nlat, nz*nt)
    case 3
        var2 = dims_tar(var1, 2);
        var2 = dims_tar(var2, 1);
        
    % MODE 4: Keep the last dimension and tar the rest.
    %         e.g. (node, nsiglay, nt)  ---> (node*nsiglay, nt)
    %         e.g. (nlon, nlat, nz, nt) ---> (nlon*nlat*nz, nt)
    case 4
        dims1 = size(var1);
        var2 = reshape(var1, [], dims1(end));
    otherwise
        error('UNKOWN mode.')
        
end