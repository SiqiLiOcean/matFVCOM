%==========================================================================
% Find the nearest node/cell point id to the input (x0, y0)
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% 2021-09-17
%
% Updates:
%
%==========================================================================
function [n, d] = f_find_nearest(fgrid, x0, y0, LOCATION)

switch lower(LOCATION)
    case 'node'
        x = fgrid.x;
        y = fgrid.y;
    case 'cell'
        x = fgrid.xc;
        y = fgrid.yc;
    otherwise
        error('Wrong LOCATION type. It should be node or cell')
end


[n, d] = knnsearch([x,y], [x0(:) y0(:)]);


