%==========================================================================
% matFVCOM toolbox
%
% example: Draw 2d figures
%       --- f_load_grid
%       --- f_2d_mesh
%       --- f_2d_image
%       --- f_2d_contour
%       --- f_2d_boundary
%       --- f_2d_mask_boundary
%
% Siqi Li, SMAST
% 2021-03-22
%==========================================================================

clc
clear

%--------------------------------------------------------------------------
% Input file path and name
file = 'H:\tools\matFVCOM\data\gom3_example.nc';



%--------------------------------------------------------------------------
% Draw FVCOM 2d mesh figure, and highlight the boundary lines 
f = f_load_grid(file, 'xy');

figure
hold on
h1 = f_2d_mesh(f);
h2 = f_2d_boundary(f);
axis([min(f.x) max(f.x) min(f.y) max(f.y)])

%--------------------------------------------------------------------------
% Draw FVCOM 2d image figure on node: zeta 
zeta = ncread(file, 'zeta', [1 1], [Inf 1]);

figure
h = f_2d_image(f, zeta);
colorbar

%--------------------------------------------------------------------------
% Draw FVCOM 2d contour figure on node: temperature 
temp = ncread(file, 'temp', [1 1 1], [Inf 1 1]);

figure
hold on
h1 = f_2d_image(f, temp);
h2 = f_2d_contour(f, temp);
h3 = f_2d_mask_boundary(f);
colorbar
axis([min(f.x) max(f.x) min(f.y) max(f.y)])


%--------------------------------------------------------------------------
% Draw FVCOM 2d image & contour figure on cell: current velocity
u = ncread(file, 'u', [1 1 1], [Inf 1 1]);
v = ncread(file, 'v', [1 1 1], [Inf 1 1]);
current = sqrt(u.^2 + v.^2);

figure
hold on
h1 = f_2d_image(f, current);
h2 = f_2d_contour(f, current, 'TextList', [0.5 1 1.5]);
colorbar
caxis([0 2])


