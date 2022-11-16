%==========================================================================
% Draw transect WRF mesh
%
% input  : x   (x coordinate)
%          y   (y coordinate)
%          deplay  (depth on node, sigma layer)
%          (The variables above will be got from fgrid)
%          x0  (lon/x on transect points)
%          y0  (lat/y on transect points)
%          (Optional)
%          'it',  the time to draw
%          'npixel', 200 the pixel number on one direction (horizontal or
%                        vertical), default is 200.
%          the rest settings for the figure
% 
% output : h (figure handle)
%
% Siqi Li, SMAST
% 2021-06-21
%==========================================================================
function h = w_transect_mesh(wgrid, x0, y0, varargin)

% % Initial settings
% it = 1;
% zlim = [];
% npixel = 200;
% 
% i = 1;
% while i<=length(varargin)
%     switch lower(varargin{i})
%         case 'zlim'
%             zlim = varargin{i+1};
%             varargin(i:i+1) = [];
%             i = i - 2;
%         case 'it'
%             it = varargin{i+1};
%             varargin(i:i+1) = [];
%             i = i - 2;
%         case 'npixel'
%             npixel = varargin{i+1};
%             varargin(i:i+1) = [];
%             i = i - 2;
%     end
%             
%     i = i + 2;
% end
varargin = read_varargin(varargin, {'it', 'npixel', 'VerticalType'}, {1, 200, 'Z'});

x = wgrid.x;
y = wgrid.y;

switch upper(VerticalType)
    case 'P'
        z = wgrid.p(:,:,:,it);
    case 'Z'
        z = wgrid.z(:,:,:,it);
    otherwise
        error('Vertical_type options: layer or level.')
end


% Calculate the pixels on the horizontal
[x_sec, y_sec, d_sec] = interp_transect_pixel_horizontal(x0, y0, 'npixcel', npixel);


% dims = size(z);
% x = reshape(x, dims(1)*dims(2), 1);
% y = reshape(y, dims(1)*dims(2), 1);
% z = reshape(z, dims(1)*dims(2), dims(3));
% depth2 = interp_horizontal(x, y, z, x_sec, y_sec);
depth2 = interp_2d('BI', z, x, y, x_sec, y_sec);



h = plot(d_sec, depth2(:,:), 'k-');


if strcmp(VerticalType, 'P')
    set(gca,'Ydir','reverse')
end

if (~isempty(varargin))
    set(h, varargin{:});
end

xlim([min(d_sec) max(d_sec)])
% if ~isempty(zlim)
%     ylim(zlim)
% end
