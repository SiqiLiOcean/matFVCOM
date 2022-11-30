%==========================================================================
% Draw transect fvcom mesh
%
% input  : x   (x coordinate)
%          y   (y coordinate)
%          deplay  (depth on node, sigma layer)
%          (The variables above will be got from fgrid)
%          vertical_type 'layer' for half, 'level' for full
%          x0  (lon/x on transect points)
%          y0  (lat/y on transect points)
%          (Optional)
%          'npixel', 200 the pixel number on one direction (horizontal or
%                        vertical), default is 200.
%          the rest settings for the figure
% output : h (figure handle)
%
% Siqi Li, SMAST
% 2020-07-16
%==========================================================================
function h = f_transect_mesh(fgrid, x0, y0, varargin)

% % Initial settings
% npixel = 200;
% 
% i = 1;
% while i<=length(varargin)
%     switch lower(varargin{i})
%         case 'npixel'
%             npixel = varargin{i+1};
%             varargin(i:i+1) = [];
%             i = i - 2;
%     end
%     
%     i = i + 2;
% end
varargin = read_varargin(varargin, {'npixel', 'VerticalType'}, {200, 'Layer'});

x1 = fgrid.x;
y1 = fgrid.y;
nv1 = fgrid.nv;

switch lower(VerticalType)
    case 'layer'
        depth1 = fgrid.deplay;
    case 'level'
        depth1 = fgrid.deplev;
    otherwise
        error('Vertical_type options: layer or level.')
end


% Calculate the pixels on the horizontal
[x_sec, y_sec, d_sec] = interp_transect_pixel_horizontal(x0, y0, 'npixel', npixel);



% depth2 = interp_horizontal(x1, y1, depth1, x_sec, y_sec);
depth2 = interp_2d('TRI', depth1, x1, y1, nv1,  x_sec, y_sec);

h = plot(d_sec, -depth2(:,:), 'k-');

if (~isempty(varargin))
    set(h, varargin{:});
end

xlim([min(d_sec) max(d_sec)])
% if ~isempty(zlim)
%     ylim(zlim)
% end
