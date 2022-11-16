%==========================================================================
% Calculate the polygon intersect
%
% input  :
%   px1 ---
%   py1 ---
%   px2 ---
%   py2 ---
% 
% output :
%   x   ---
%   y   ---
%
% Siqi Li, SMAST
% 2022-05-26
%
% Updates:
%
%==========================================================================
function [x, y] = poly_intersect(px1, py1, varargin)

switch nargin
    case 3
        poly2 = varargin{1};
    case 4
        poly2 = polyshape(varargin{1}, varargin{2}, 'KeepCollinearPoints', true);
end

if isnan(px1(1))
    px1 = px1(2:end);
    py1 = py1(2:end);
end
if ~isnan(px1(end))
    px1(end+1) = nan;
    py1(end+1) = nan;
end

i_nan = find(isnan(px1));
n = length(i_nan);
i1= [1 i_nan(1:n-1)+1];
i2 = i_nan - 1;

x = [];
y = [];
for i = 1 : n
    poly1 = polyshape(px1(i1(i):i2(i)), py1(i1(i):i2(i)), 'KeepCollinearPoints', true);
    poly = intersect(poly1, poly2);
    
    line_x = poly.Vertices(:,1);
    line_y = poly.Vertices(:,2);
    if isempty(line_x)
        continue
    end
    
    dist = sqrt((line_x(1)-line_x(end))^2 + (line_y(1)-line_y(end))^2);
    if dist>1e-5
        line_x(end+1) = line_x(1);
        line_y(end+1) = line_y(1);
    end
    

    x = [x; line_x; nan];
    y = [y; line_y; nan];
end



