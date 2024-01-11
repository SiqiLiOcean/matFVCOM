%==========================================================================
% Check if the grid is a global one based on (x,y)
%
% input  :
%   x ---
%   y ---
% output :
%   type --- grid type, 'Global' or 'Regional'
%
% Siqi Li, SMAST
% 2023-01-03
%
% Updates:
%
%==========================================================================
function type = check_grid_type(x, y)

eps = 1e-7;

xlims = minmax(x);
ylims = minmax(y);
type = 'Regional';
if ylims(1)>=-90 && abs(ylims(2)-90)<eps && abs(xlims(1))<eps && abs(xlims(2)-360)<eps
    if all(histcounts(x, 0:5:360)>0)
        type = 'Global';
    end
elseif ylims(1)>=-90 && abs(ylims(2)-90)<eps && abs(xlims(1)+180)<eps && abs(xlims(2)-180)<eps
    if all(histcounts(x, -180:5:180)>0)
        type = 'Global';
    end   
end
