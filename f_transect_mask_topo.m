function [h, poly_topo] = f_transect_mask_topo(fgrid, x, y, varargin)

patch_color = [222,184,135]/255;   % tan
% npixel = 200;
% 
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
%     end
%     i = i + 2;
% end
varargin = read_varargin(varargin, {'npixel', 'zlims'}, {200, []});
varargin = read_varargin2(varargin, {'Geo'});

% [poly_topo, h_topo] = interp_transect_topo(fgrid.x, fgrid.y, -fgrid.h, x, y, 'npixel', npixel);

if Geo
    [x_sec, y_sec, d_sec] = interp_transect_pixel_horizontal(x, y, 'npixel', npixel, 'Geo');
else
    [x_sec, y_sec, d_sec] = interp_transect_pixel_horizontal(x, y, 'npixel', npixel);
end

varargin = read_varargin2(varargin, {'Extrap'});
varargin = read_varargin(varargin, {'K'}, {7});
% if Extrap
    h_topo = interp_2d(-fgrid.h, 'TRI', fgrid.x, fgrid.y, fgrid.nv, x_sec, y_sec, 'Extrap', 'K', K);
% else
    % h_topo = interp_2d(-fgrid.h, 'TRI', fgrid.x, fgrid.y, fgrid.nv, x_sec, y_sec, 'K', K);
% end

z1 = min(h_topo);
z2 = max(h_topo);


if z1 == z2
    h = [];
    poly_topo = [];
else
    
    if ~isempty(zlims)
        z1 = zlims(1);
    end
    lx = [d_sec(:)' d_sec(end) d_sec(1) d_sec(1)];
    ly = [h_topo(:)' z1 z1 h_topo(1)];

    poly_topo = polyshape(lx, ly, ...
                          'KeepCollinearPoints', true);
%     if ~isempty(zlims)
%         poly = polyshape([d_sec(1) d_sec(end) d_sec(end) d_sec(1) d_sec(1)], ...
%                          [zlims(1) zlims(1) zlims(2) zlims(2) zlims(1)]);
%         poly_topo = intersect(poly, poly_topo);
%     end
    
    h = plot(poly_topo);
    set(h, 'LineStyle', 'none')
    set(h, 'FaceColor', patch_color)
    set(h, 'FaceAlpha', 1)
    
    if (~isempty(varargin))
        set(h, varargin{:});
    end
   
%     xlim([min(poly_topo.Vertices(:,1)) max(poly_topo.Vertices(:,1))])

    
end




% h = patch(poly_bottom(:,1), poly_bottom(:,2), patch_color, ...
%           'EdgeColor', patch_color);
      


% ylim(zlims)
% set(gca, 'Layer', 'Top')
