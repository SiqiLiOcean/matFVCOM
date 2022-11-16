%==========================================================================
% Interpolate the pixels on the transect
%
% input  : 
%          zlim, [min depth, max depth] (m, positive for water depth)
%          'npixel', 200 the pixel number on one direction (horizontal or
%                        vertical), default is 200.
%
% output : h_sec, depth column for setion points (m, positive for water 
%                 depth) 
%
% Siqi Li, SMAST
% 2021-06-21
%==========================================================================
function h_sec = interp_transect_pixel_vertical(zlims, varargin)

% % Initiallization
% npixel=200;
% 
% k=1;
% % Pixel number
% while k<=length(varargin)
%     switch lower(varargin{k})
%         case 'npixel'
%             npixel=varargin{k+1};
%     end
%     k=k+2;
% end
varargin = read_varargin(varargin, {'npixel'}, {200});


% Calculate the h of each transect point
h_sec=linspace(zlims(1), zlims(2), npixel);

end