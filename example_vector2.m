clc
clear

file = 'data/fvcom_example.nc';

f = f_load_grid(file);
u = ncread(file, 'u', [1 1 1], [Inf 1 1]);
v = ncread(file, 'v', [1 1 1], [Inf 1 1]);

k = rarefy(f.xc, f.yc, 20000);
% 


% x = f.xc(k);
% y = f.yc(k);
% u = u(k);
% v = v(k);


figure
hold on
f_2d_boundary(f);
f_2d_range(f);
h = f_2d_vector2(f, u, v, 'List', k, 'Scale', 0.8);
set(h, 'FaceColor', 'k', 'EdgeColor', 'k')