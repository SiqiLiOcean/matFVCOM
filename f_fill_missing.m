%==========================================================================
% Fill the NaN with the nearest points
%
% input  :
%   fgrid ---
%   var1  ---
% 
% output :
%   var2  ---
%
% Siqi Li, SMAST
% 2023-01-03
%
% Updates:
%
%==========================================================================
function var2 = f_fill_missing(fgrid, var1)


n = length(var1);

switch n
    case fgrid.node
        x = fgrid.x;
        y = fgrid.y;
    case fgrid.nele
        x = fgrid.xc;
        y = fgrid.yc;
    otherwise
        error('Wrong input size.')
end

i_nan = find(isnan(var1));
i_num = find(~isnan(var1));

k = knnsearch([x(i_num) y(i_num)], [x(i_nan) y(i_nan)]);
var2 = var1;

var2(i_nan) = var1(i_num(k));
