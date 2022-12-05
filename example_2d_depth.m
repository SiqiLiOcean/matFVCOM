clc
clear

file = './data/fvcom_example.nc';

f = f_load_grid(file);

temp = ncread(file, 'temp');



temp1 = f_interp_depth(f, temp, [0 5 10 15 300]);


figure
subplot(1,2,1)
hold on
f_2d_boundary(f);
f_2d_image(f, temp1(:,5,1))
subplot(1,2,2)
f_2d_boundary(f);
f_2d_image(f, temp(:,1,1))
