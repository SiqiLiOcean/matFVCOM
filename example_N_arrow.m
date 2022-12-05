clc
clear

f1 = f_load_grid('./data/gom3_grid.nc', 'xy');
f2 = f_load_grid('./data/gom3_grid.nc', 'xy', 'rotate', 30);


close all
figure
hold on
f_2d_mesh(f1);
% axis equal 
N_arrow(6e5, 3e5);



figure
f_2d_mesh(f2);
axis equal
axis tight
N_arrow(2e5, -4.5e5, 'theta', f2.rotate);
% N_arrow(2e5, -4.5e5);


