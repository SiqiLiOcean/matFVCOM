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
function [var2, dist] = f_fill_missing(fgrid, var1)


n = size(var1, 1);

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

i_nan = find(isnan(var1(:,1)));
i_num = find(~isnan(var1(:,1)));

% k = ksearch([x(i_nan) y(i_nan)], [x(i_num) y(i_num)]);
[k, d] = ksearch([x(i_num) y(i_num)], [x(i_nan) y(i_nan)]);

var2 = var1;

var2(i_nan,:) = var1(i_num(k),:);
dist = nan(n, 1);
dist(i_nan) = d;