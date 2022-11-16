%==========================================================================
% Mask the region out of the WRF grid boundary
%
% input  : x   (x coordinate)
%          y   (y coordinate)
%          nv  (triangle matrix)
%          (the three variables above will be got from wgrid)
% output : h (figure handle)
%
% Siqi Li, SMAST
% 2021-06-21
%==========================================================================
function h = w_2d_mask_boundary(wgrid, varargin)


x = wgrid.x(:);
y = wgrid.y(:);

% if isfield(wgrid, 'bdy_x') && isfield(wgrid, 'bdy_y')
    bdy_x = wgrid.bdy_x;
    bdy_y = wgrid.bdy_y;
% else
% %     disp('Calculate boundary first...')
%     [bdy_x, bdy_y] = w_calc_boundary(wgrid);
%     wgrid.bdy_x = bdy_x;
%     wgrid.bdy_y = bdy_y;
%     assignin('base', inputname(1), wgrid)
% end


% Get the xlim and ylim of the current figure
xlim = get(gca, 'xlim');
ylim = get(gca, 'ylim');







pct = 0.01;
x1 = min(x)-pct*(max(x)-min(x));
y1 = min(y)-pct*(max(y)-min(y));
x2 = max(x)+pct*(max(x)-min(x));
y2 = max(y)+pct*(max(y)-min(y));

xl = [x1 x2 x2 x1 nan bdy_x(:)'];
yl = [y1 y1 y2 y2 nan bdy_y(:)'];

pgon = polyshape(xl, yl);

hold on
h = plot(pgon);
set(h, 'LineStyle', 'none');
set(h, 'FaceColor', 'w');
set(h, 'FaceAlpha', 1);
axis([xlim(1) xlim(2) ylim(1) ylim(2)])

if ~isempty(varargin)
    set(h, varargin{:});
end

set(gca, 'Layer', 'Top')