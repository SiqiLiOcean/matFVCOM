%==========================================================================
% Calculate the isoline of one certain level
% 
% Input  : --- fgrid
%          --- var, input variable (in the size of node or cell)
%          --- level, the level of isoline
%
% Output : --- level_x, x of isolines
%          --- level_y, y of isolines
% 
% Usage  : [x, y] = f_isoline(f, f.h, 5000);
%
% v1.0
%
% Siqi Li
% 2021-04-15
%
% Updates:
%
%==========================================================================
function [level_x, level_y] = f_isoline(fgrid, var, level)

if length(level(:)) > 1
    error('The input level should be one number.')
end

node = fgrid.node;
nele = fgrid.nele;

switch length(var)
    case node
        x = fgrid.x;
        y = fgrid.y;
    case nele
        x = fgrid.xc;
        y = fgrid.yc;
    otherwise
        error('Wrong size of input variable.')
end


x = double(x);
y = double(y);
var = double(var);

xlim = [min(x) max(x)];
ylim = [min(y) max(y)];

xl = linspace(xlim(1), xlim(2), 300);
yl = linspace(ylim(1), ylim(2), 300);


[yy, xx] = meshgrid(yl, xl);
zz = griddata(x, y, var, xx, yy);

C = contourc(xl, yl, zz', [level level]);


k = [];
level_x = [];
level_y = [];
% z = [];
i1 = 1;
while i1<size(C,2)
    k = [k; i1];
    
    i2 = i1 + C(2,i1)+1;
    level_x = [level_x nan C(1,i1+1:i2-1)];
    level_y = [level_y nan C(2,i1+1:i2-1)];
%     z = [z C(1,i1)];
    i1 = i2;
end
