%==========================================================================
% Calculate the covering index
% 
%
% input  :
%   x1  --- the input array
%   x0  --- the original array
% 
% output :
%   i1
%   i2
%   n
% Siqi Li, SMAST
% 2023-01-11
%
% Updates:
%
%==========================================================================
function [i1, i2, n] = calc_data_index(x1, x0)



xmin = min(double(x1(:)));
xmax = max(double(x1(:)));


i1 = nan;
i2 = nan;
for i = 1 : length(x0)-1
    if x0(i)<=xmin && x0(i+1)>=xmin
        i1 = i;
        break
    end
end
for i = 2 : length(x0)
    if x0(i-1)<=xmax && x0(i)>=xmax
        i2 = i;
        break
    end
end


n = i2 - i1 + 1;
