%==========================================================================
%   
% input  : 
% 
% output :
%
% Siqi Li, SMAST
% yyyy-mm-dd
%
% Updates:
%
%==========================================================================
function [x2, y2] = rotate_theta(x1, y1, theta)

theta1 = atan2d(y1, x1);
r = sqrt(x1.^2 + y1.^2);


x2 = r .* cosd(theta1+theta);
y2 = r .* sind(theta1+theta);

end