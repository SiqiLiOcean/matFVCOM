%==========================================================================
% Convert the lines from mat format into cell format
%
% input  :
%   x   --- x in mat format
%   y   --- y in mat format
% 
% output :
%   cell_x --- x in cell format
%   cell_y --- y in cell format
%
%
% Line in mat format
%   x = [1 1 1 nan 1 2 3 nan];
%   y = [1 2 3 nan 2 2 2 nan];
% Line in cell format
%   cell_x{1} = [1 1 1 nan];
%   cell_y{1} = [1 2 3 nan];
%   cell_x{2} = [1 2 3 nan];
%   cell_y{2} = [2 2 2 nan];
%
% Siqi Li, SMAST
% 2022-07-13
%
% Updates:
%
%==========================================================================
function [cell_x, cell_y] = line_mat2cell(x, y, varargin)

% Write the input into the standard format
x = x(:)';
y = y(:)';
if isnan(x(1))
    x(1) = [];
    y(1) = [];
end
if ~isnan(x(end))
    x = [x nan];
    y = [y nan];
end

% Use nan as delimiters
k = find(isnan(x));
i2 = 0;
for i = 1 : length(k)
    i1 = i2 + 1;
    i2 = k(i);
    cell_x{i,1} = x(i1:i2);
    cell_y{i,1} = y(i1:i2);
end


