%==========================================================================
% Find out the WRF grid boundary
%
% input  : x   (x coordinate)
%          y   (y coordinate)
%          nv  (triangle matrix)
%          (the three variables above will be got from wgrid)
% output : bdy_x    (x coordinate of bdy)
%          bdy_y    (y coordinate of bdy)
%          lines_x  (x coordinate of all lines)
%          lines_y  (y coordinate of all lines)
%          bdy_id   (node id of (bdy_x, bdy_y) )
%
% Siqi Li, SMAST
% 2021-06-21
%
% Updates:
%
%==========================================================================
function [bdy_x, bdy_y, lines_x, lines_y, bdy_id] = w_calc_boundary(wgrid)

x = wgrid.x;
y = wgrid.y;
[nx, ny] = size(x);

% Calculate bdy_id
sub1 = [repmat(1,ny,1); (2:nx)'          ; repmat(nx,ny-1,1); (nx-1:-1:1)'  ];
sub2 = [(1:ny)'       ; repmat(ny,nx-1,1); (ny-1:-1:1)'     ; repmat(1,nx-1,1)];
bdy_id = sub2ind([nx,ny], sub1, sub2);

% Caluclate bdy_x and bdy_y
bdy_x = x(bdy_id);
bdy_y = y(bdy_id);
% bdy_x = [x(1,1:ny)'; x(2:nx, ny); x(nx, ny-1:-1:1)'; x(nx-1:-1:1, 1)];
% bdy_y = [y(1,1:ny)'; y(2:nx, ny); y(nx, ny-1:-1:1)'; y(nx-1:-1:1, 1)];

% Calculate lines_x and lines_y
lines_x = [];
lines_y = [];
for i = 1 : nx
    lines_x = [lines_x; x(i,:)'; nan];
    lines_y = [lines_y; y(i,:)'; nan];
end
for j = 1 : ny
    lines_x = [lines_x; x(:,j); nan];
    lines_y = [lines_y; y(:,j); nan];
end

% wgrid.bdy_x = bdy_x;
% wgrid.bdy_y = bdy_y;
% wgrid.lines_x = lines_x;
% wgrid.lines_y = lines_y;
% assignin('caller', inputname(1), wgrid);
