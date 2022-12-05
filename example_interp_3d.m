clc
clear

fin='./data/gom3_example.nc';
fout='./data/gom4_grid.nc';


std=[0:10 12:2:30 35:5:50 60:10:100 120:20:200 250:50:500 600:100:1500];

%--------------------------------------------------------------------------
% Read input grid
gom3 = f_load_grid(fin, 'xy');
gom4 = f_load_grid(fout, 'xy');

%==========================================================================
% 3d interpolation of variables on node

%--------------------------------------------------------------------------
% Read the field
temp0 = ncread(fin, 'temp', [1 1 1], [Inf Inf 1]);

%--------------------------------------------------------------------------
% Method 1: Calculate the weight and then do the interpolation
weight1 = f_interp_3d_calc_weight(gom3, temp0, gom4, std);
temp_out1 = interp_3d_via_weight(temp0, weight1);

%--------------------------------------------------------------------------
% Method 2: Directly do the interpolation
temp_out2 = f_interp_3d(gom3, temp0, gom4, std);

figure
subplot(2,3,1)
f_2d_image(gom3, temp0(:,1));
subplot(2,3,2)
f_2d_image(gom4, temp_out1(:,1));
subplot(2,3,3)
f_2d_image(gom4, temp_out2(:,1));
subplot(2,3,4)
f_2d_image(gom3, temp0(:,end));
subplot(2,3,5)
f_2d_image(gom4, temp_out1(:,end));
subplot(2,3,6)
f_2d_image(gom4, temp_out2(:,end));
%==========================================================================
% 3d interpolation of variables on node

%--------------------------------------------------------------------------
% Read the field
u0 = ncread(fin, 'u', [1 1 1], [Inf Inf 1]);

%--------------------------------------------------------------------------
% Method 1: Calculate the weight and then do the interpolation
weight2 = f_interp_3d_calc_weight(gom3, u0, gom4, std);
u_out1 = interp_3d_via_weight(u0, weight2);

%--------------------------------------------------------------------------
% Method 2: Directly do the interpolation
u_out2 = f_interp_3d(gom3, u0, gom4, std);

figure
subplot(2,3,1)
f_2d_image(gom3, u0(:,1));
subplot(2,3,2)
f_2d_image(gom4, u_out1(:,1));
subplot(2,3,3)
f_2d_image(gom4, u_out2(:,1));
subplot(2,3,4)
f_2d_image(gom3, u0(:,end));
subplot(2,3,5)
f_2d_image(gom4, u_out1(:,end));
subplot(2,3,6)
f_2d_image(gom4, u_out2(:,end));