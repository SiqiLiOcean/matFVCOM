%==========================================================================
% Calculate the mean of angle data
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% 2022-12-15
%
% Updates:
%
%==========================================================================
function theta2 = angle_mean(theta1, varargin)

varargin = read_varargin(varargin, {'dim'}, {1});

if numel(theta1) == length(theta1)
    theta1 = theta1(:);
end

theta2 = atan2d(sum(sind(theta1),dim), sum(cosd(theta1),dim));