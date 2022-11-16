%==========================================================================
% Draw the FVCOM grid boundary
%
% input  : x   (x coordinate)
%          y   (y coordinate)
%          nv  (triangle matrix)
%          (The variables above will be got from fgrid)
% output : h (figure handle)
%
% Siqi Li, SMAST
% 2021-03-10
%==========================================================================
function h = f_2d_boundary(fgrid, varargin)

varargin = read_varargin2(varargin, {'Patch'});

% if isfield(fgrid, 'bdy_x') && isfield(fgrid, 'bdy_y')
    bdy_x = [fgrid.bdy_x{:}];
    bdy_y = [fgrid.bdy_y{:}];
% else
%     disp('Calculate boundary first...')
%     [bdy_x, bdy_y] = f_calc_boundary(fgrid);
%     fgrid.bdy_x = bdy_x;
%     fgrid.bdy_y = bdy_y;
%     assignin('base', inputname(1), fgrid)
% end

if Patch
    bdy = polyshape([bdy_x(:) bdy_y(:)], 'KeepCollinearPoints', true);
    h = plot(bdy, 'EdgeColor', 'w', ...
                  'FaceColor', 'w', ...
                  'FaceAlpha', 1);
%     h = patch(bdy_x, bdy_y, 'w', 'EdgeColor', 'r', ...
%                                  'FaceColor', 'r', ...
%                                  'FaceAlpha', 1);
else
    h = plot(bdy_x, bdy_y, 'r-', 'linewidth', .6);
end
 
% pgon = polyshape(bdy_x, bdy_y);
% 
% h = plot(pgon);
% set(h, 'LineStyle', '-');
% set(h, 'Linewidth', 1.3)
% set(h, 'EdgeColor', 'r');
% set(h, 'FaceColor', 'w');
% set(h, 'EdgeAlpha', 1);


if ~isempty(varargin)
    set(h, varargin{:});
end

end

