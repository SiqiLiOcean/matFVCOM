clc
clear

file = './data/fvcom_example.nc';

f = f_load_grid(file);

temp = ncread(file, 'temp');

temp1 = f_smooth(f, temp);
temp2 = f_smooth(f, temp, 'CenterWeight', 0);

close all
figure
subplot(1,3,1)
hold on
f_2d_image(f, temp(:,1,1));
colorbar('Northoutside')
f_2d_contour(f, temp(:,1,1), 'LevelList', [-.5 0 .5]);
f_2d_mask_boundary(f);
subplot(1,3,2)
hold on
f_2d_image(f, temp1(:,1,1));
colorbar('Northoutside')
f_2d_contour(f, temp1(:,1,1), 'LevelList', [-.5 0 .5]);
f_2d_mask_boundary(f);
subplot(1,3,3)
hold on
f_2d_image(f, temp2(:,1,1));
colorbar('Northoutside')
f_2d_contour(f, temp2(:,1,1), 'LevelList', [-.5 0 .5]);
f_2d_mask_boundary(f);