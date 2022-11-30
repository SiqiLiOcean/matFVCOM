%==========================================================================
% Calculate vertically averaged FVCOM variables
%
% input  :
%   fgrid   --- fvcom grid cell
%   var     --- variable
% 
% output :
%   var_a   --- column-averaged variable
%
% Siqi Li, SMAST
% 2021-10-20
%
% Updates:
%
%==========================================================================
function var_a = f_mean_column(fgrid, var, varargin)


n = size(var, 1);
nz = size(var, 2);
nt = size(var, 3);

switch nz
    case fgrid.kb
        switch n
            case fgrid.node
                sig = fgrid.siglev;
                dsig = fgrid.siglev(:,1:end-1) - fgrid.siglev(:,2:end);
            case fgrid.nele
                sig = fgrid.siglevc;
                dsig = fgrid.siglevc(:,1:end-1) - fgrid.siglevc(:,2:end);
            otherwise
                error('Wrong size of the 1st dimension.')
        end
        
        var = ( var(:,1:end-1,:) + var(:,2:end,:) ) /2;

    case fgrid.kbm1
        switch n
            case fgrid.node
                sig = fgrid.siglay;
                dsig = fgrid.siglev(:,1:end-1) - fgrid.siglev(:,2:end);
            case fgrid.nele
                sig = fgrid.siglayc;
                dsig = fgrid.siglevc(:,1:end-1) - fgrid.siglevc(:,2:end);
            otherwise
                error('Wrong size of the 1st dimension.')
        end
    otherwise
        error('Wrong size of the 2nd dimension.')
end



for it = 1 : nt
    var_a(:,it) = sum(var(:,:,it) .* dsig, 2);
end



