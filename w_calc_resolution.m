%==========================================================================
% Calculate the resolution of WRF grd
%
% input  : wgrid
% output : d_mid (mean resolution on cell center of the four edges)
%
% Siqi Li, SMAST
% 2022-04-28
%==========================================================================
function d_mid = w_calc_resolution(wgrid, varargin)


varargin = read_varargin2(varargin, {'Geo'});
varargin = read_varargin(varargin, {'R'}, {6371e3}');


x = wgrid.x;
y = wgrid.y;
nx = wgrid.nx;
ny = wgrid.ny;

d_we = calc_distance(x(1:nx-1,:), y(1:nx-1,:), x(2:nx,:), y(2:nx,:), Geo, 'R', R);
d_sn = calc_distance(x(:,1:ny-1), y(:,1:ny-1), x(:,2:ny), y(:,2:ny), Geo, 'R', R);

d_mid = (d_we(1:nx-1,1:ny-1) + d_we(1:nx-1,2:ny) + d_sn(1:nx-1,1:ny-1) + d_sn(2:nx,1:ny-1)) / 4;

disp(' ')
disp('------------------------------------------------')
fprintf(' Resolution: %f ~ %f \n', min(min(d_mid)), max(max(d_mid)))
disp('------------------------------------------------')
disp(' ')