%==========================================================================
% Re-set the nesting node location to match the given ones 
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% 2021-11-02
%
% Updates:
%
%==========================================================================
function fgrid2 = f_nesting_match(fgrid, nesting_x, nesting_y, nesting_h)

x = fgrid.x;
y = fgrid.y;
nv = fgrid.nv;
if nargin == 3
    nesting_h = nan;
elseif nargin == 4
    h = fgrid.h;
end


% Set the longitude and latitude exactly the same on the nesting boundary.
nesting_id = knnsearch([fgrid.x, fgrid.y], [nesting_x, nesting_y]);
x(nesting_id) = nesting_x;
y(nesting_id) = nesting_y;
if isnan(nesting_h)
    fgrid2 = f_load_grid(x, y, nv);
else
    h(nesting_id) = nesting_h;
    length(x)
    length(h)
    fgrid2 = f_load_grid(x, y, nv, h);
end

% % fgrid.x = ftmp.x;
% % fgrid.y = ftmp.y;
% % fgrid.xc = ftmp.xc;
% % fgrid.yc = ftmp.yc;
% % fgrid.bdy_x = ftmp.bdy_x;
% % fgrid.bdy_y = ftmp.bdy_y;
% % fgrid.lines_x = ftmp.lines_x;
% % fgrid.lines_y = ftmp.lines_y;
% % 
% % variables_list = {'x', 'y', 'xc', 'yc', 'bdy_x', 'bdy_y', 'lines_x', 'line_y', ...
% %                   'h', 'hc', ''}


