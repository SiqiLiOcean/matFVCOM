%==========================================================================
% Calculate the circle (x, y) of given center and radius.
%
% input  :
%   R   --- radius
%   x0  --- center x (default is 0)
%   y0  --- center y (default is 0)
% 
% output :
%   x
%   y
%
% usage:
%   [x, y] = calc_circle(R);
%   [x, y] = calc_circle(R, x0, y0)
%
% Siqi Li, SMAST
% 2022-11-19
%
% Updates:
%
%==========================================================================
function [x, y] = calc_circle(R, x0, y0)

if ~exist('x0', 'var') || ~exist('y0', 'var')
    x0 = 0;
    y0 = 0;
end

theta = 0 : 0.5 : 360;

x = x0 + cosd(theta) * R;
y = y0 + sind(theta) * R;
