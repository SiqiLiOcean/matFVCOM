%==========================================================================
% Calculate m-polygon area in Cartisian Coordinate or
% Geo-referenced Coordinate.
%
% input  :
%   px --- polygon x (n, m)
%   py --- polygon y (n, m)
%   'R'      --- earth radius
%   'Geo'
%
% output :
%
% Siqi Li, SMAST
% 2022-03-01
%
% Updates:
%
%==========================================================================
function S = calc_area(px, py, varargin)

varargin = read_varargin(varargin, {'R'}, {6371e3});
varargin = read_varargin2(varargin, {'Geo'});

if size(px, 2)==1
  px = px';
  py = py';
end

[n, m] = size(px);

xc = mean(px, 2);
yc = mean(py, 2);

area = zeros(n, m);
for i = 1 : m
    if i == m
        x = [xc px(:,m), px(:,1)];
        y = [yc py(:,m), py(:,1)];
    else
        x = [xc px(:,i), px(:,i+1)];
        y = [yc py(:,i), py(:,i+1)];
    end
    area(:,i) = calc_triangle_area(x, y, 'R', R, Geo);   
    
end

S = sum(area, 2);

end



function S = calc_triangle_area(x, y, varargin)

% Calculate the area of triangles
% x --- triangle x (n,3)
% y --- triangle y (n,3)


varargin = read_varargin(varargin, {'R'}, {6371e3});
varargin = read_varargin2(varargin, {'Geo'});

x1 = [x(:,[1 2 3])];
y1 = [y(:,[1 2 3])];
x2 = [x(:,[2 3 1])];
y2 = [y(:,[2 3 1])];

% lengh
l = calc_distance(x1, y1, x2, y2, 'R', R, Geo);


L_half = sum(l, 2) / 2;

% area
S = L_half .* (L_half-l(:,1)) .* (L_half-l(:,2)) .* (L_half-l(:,3));
S = sqrt(abs(S));

end
    
