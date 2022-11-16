function h = w_transect_mask_topo(wgrid, x0, y0, varargin)

patch_color = [222,184,135]/255;   % tan
% zlim = [];
% npixel = 200;
% it = 1;

% i = 1;
% while i<=length(varargin)
%     switch lower(varargin{i})
%         case 'color'
%             patch_color = varargin{i+1};
%             varargin(i:i+1) = [];
%             i = i-2;
%         case 'npixel'
%             npixel = varargin{i+1};
%             varargin(i:i+1) = [];
%             i = i-2;
%         case 'zlim'
%             zlim = varargin{i+1};
%             varargin(i:i+1) = [];
%             i = i-2;
%         case 'it'
%             it = varargin{i+1};
%             varargin(i:i+1) = [];
%             i = i-2;
%     end
%     i = i + 2;
% end
varargin = read_varargin(varargin, {'npixel', 'zlims', 'it'}, {200, [], 1});



x = wgrid.x;
y = wgrid.y;
z = wgrid.hgt(:,:,it);
% z = z(:);

% [poly_topo, h_topo] = interp_transect_topo(x, y, z, x0, y0, 'zlim', zlim, 'npixel', npixel);
[x_sec, y_sec, d_sec] = interp_transect_pixel_horizontal(x0, y0, 'npixel', npixel);
h_topo = interp_2d('BI', z, x, y, x_sec, y_sec);

z1 = min(h_topo);
z2 = max(h_topo);

if z1 == z2
    h = [];
    poly_topo = [];
else
    poly_topo = polyshape([d_sec(:)' d_sec(end) d_sec(1) d_sec(1)], ...
                          [h_topo(:)' z1 z1 h_topo(1)], ...
                          'KeepCollinearPoints', true);
    if ~isempty(zlims)
        poly = polyshape([d_sec(1) d_sec(end) d_sec(end) d_sec(1) d_sec(1)], ...
                         [zlims(1) zlims(1) zlims(2) zlims(2) zlims(1)], ...
                         'KeepCollinearPoints', true);
        poly_topo = intersect(poly, poly_topo);
    end
    
    h = plot(poly_topo);
    set(h, 'LineStyle', 'none')
    set(h, 'FaceColor', patch_color)
    set(h, 'FaceAlpha', 1)
    
    if (~isempty(varargin))
    set(h, varargin{:});
    end
    
    xlim([min(poly_topo.Vertices(:,1)) max(poly_topo.Vertices(:,1))])
    
end
