%==========================================================================
% Interpolate the pixels on the transect
%
% input  : 
%          x, x coordinate of the section points (m or degree)
%          y, y coordinate of the section points (m or degree)
%          zlim, [min depth, max depth] (m, positive for water depth)
%          'npixel', 200 the pixel number on one direction (horizontal or
%                        vertical), default is 200.
%
% output : x_sec, x column for setion points (m or degree)
%          y_sec, y column for setion points (m or degree)
%          d_sec, distance column for setion points (m or degree)
%          h_sec, depth column for setion points (m, positive for water 
%                 depth) 
%
% Siqi Li, SMAST
% 2021-06-21
%==========================================================================
function [x_sec, y_sec, d_sec, h_sec] = interp_transect_pixel(x, y, zlims, varargin)

% Calculate the pixels on the horizontal
[x_sec, y_sec, d_sec] = interp_transect_pixel_horizontal(x, y, varargin{:});

% Calculate the pixels on the vertical
h_sec = interp_transect_pixel_vertical(zlims, varargin{:});


end