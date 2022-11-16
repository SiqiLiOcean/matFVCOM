%==========================================================================
% Draw WRF mesh boundary
% 
% Input  : --- wgrid, WRF grid cell 
%          --- varargin, settings for the plot figure
%
% Output : --- h, figure handle
% 
% Usage  : h = w_2d_boundary(wgrid);
%
% v1.0
%
% Siqi Li
% 2021-05-11
%
% Updates:
%
%==========================================================================
function h = w_2d_boundary(wgrid, varargin)


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

h = plot(bdy_x, bdy_y, 'r-', 'linewidth', 0.6);

% x = wgrid.x;
% y = wgrid.y;
% [nx, ny] = size(x);
% 
% 
% lon_bdy = [x(1,1:ny)'; x(2:nx, ny); x(nx, ny-1:-1:1)'; x(nx-1:-1:1, 1)];
% lat_bdy = [y(1,1:ny)'; y(2:nx, ny); y(nx, ny-1:-1:1)'; y(nx-1:-1:1, 1)];

% h = plot(lon_bdy, lat_bdy, 'k-', 'linewidth', 1.3, 'color', 'r');

if ~isempty(varargin)
    set(h, varargin{:});
end