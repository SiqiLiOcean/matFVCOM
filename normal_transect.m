%==========================================================================
% Given three points, output a set of (x,y) on the transect, which across
% the middle point and is normal to the lines.
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% 2021-11-27
%
% Updates:
%
%==========================================================================
function [x, y] = normal_transect(x0, y0, d, varargin)

varargin = read_varargin(varargin, {'N'}, {100});
varargin = read_varargin(varargin, {'Rotate'}, {0});
varargin = read_varargin2(varargin, {'Flip'});

switch length(x0)
    case 1
        x0 = [x0 x0 x0];
        y0 = [y0-1 y0 y0+1];
    case 2
        x_tmp = x0;
        y_tmp = y0;
        x0 = [2*x_tmp(1)-x_tmp(2) x_tmp(1) x_tmp(2)];
        y0 = [2*y_tmp(1)-y_tmp(2) y_tmp(1) y_tmp(2)];
    case 3
        % Nothing done.
    otherwise
        error('Wrong input x0 and y0')
end

theta1 = atan2d(y0(2)-y0(1), x0(2)-x0(1));
theta2 = atan2d(y0(3)-y0(2), x0(3)-x0(2));

theta3 = Rotate + 90 + (theta1+theta2) / 2;


y1 = y0(2) - d * sind(theta3);
x1 = x0(2) - d * cosd(theta3);
y2 = y0(2) + d * sind(theta3);
x2 = x0(2) + d * cosd(theta3);

x = linspace(x1, x2, N+1);
y = linspace(y1, y2, N+1);

if x1 > x2
    x = flip(x);
    y = flip(y);
end


if Flip
    x = flip(x);
    y = flip(y);
end
