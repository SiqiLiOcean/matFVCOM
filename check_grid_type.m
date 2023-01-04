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


xlims = minmax(x);
ylims = minmax(y);
type = 'Regional';
if ylims(1)>=-90 && ylims(2)<=90 && xlims(1)>=0 && xlims(2)<=360
    if all(histcounts(x, 0:5:360)>0)
        type = 'Global';
    end
elseif ylims(1)>=-90 && ylims(2)<=90 && xlims(1)>=-180 && xlims(2)<=180
    if all(histcounts(x, -180:5:180)>0)
        type = 'Global';
    end   
end