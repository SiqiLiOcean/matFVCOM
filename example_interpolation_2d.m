clc
clear

file1 = './data/fvcom_example.nc';
file2 = './data/wrf_d03_example.nc';

f = f_load_grid(file1, 'geo');
w = w_load_grid(file2);

% TRI
% weight_h = interp_2d_calc_weight('TRI', f.x, f.y, f.nv, w.x, w.y, 'Extrap');
% % weight_h = interp_2d_calc_weight('TRI', f.x, f.y, f.nv, w.x, w.y);
% var2 = interp_2d_via_weight(weight_h, f.h);
% figure
% subplot(1,2,1)
% f_2d_image(f, f.h);
% f_axis_tight(f);
% colorbar('northoutside')
% subplot(1,2,2)
% w_2d_image(w, var2);
% f_axis_tight(f);
% colorbar('northoutside')

% BI
% weight_h = interp_2d_calc_weight('BI', w.x, w.y, f.x, f.y, 'Extrap');
% % weight_h = interp_2d_calc_weight('BI', w.x, w.y, f.x, f.y);
% var2 = interp_2d_via_weight(weight_h, w.y);
% figure
% subplot(1,2,1)
% w_2d_image(w, w.y);
% f_axis_tight(f);
% caxis([35 46])
% colorbar('northoutside')
% subplot(1,2,2)
% f_2d_image(f, var2);
% f_axis_tight(f);
% caxis([35 46])
% colorbar('northoutside')


% ID: WRF to FVCOM
weight_h = interp_2d_calc_weight('ID', w.x, w.y, f.x, f.y);
var2 = interp_2d_via_weight(weight_h, w.hgt);
figure
subplot(1,2,1)
w_2d_image(w, w.hgt(:,:,2));
f_axis_tight(f);
% caxis([35 46])
colorbar('northoutside')
subplot(1,2,2)
f_2d_image(f, var2(:,2));
f_axis_tight(f);
% caxis([35 46])
colorbar('northoutside')


% ID: FVCOM to WRF
weight_h = interp_2d_calc_weight('ID', f.x, f.y, w.x, w.y);
var2 = interp_2d_via_weight(weight_h, f.y);
figure
subplot(1,2,1)
f_2d_image(f, f.y);
f_axis_tight(f);
caxis([35 46])
colorbar('northoutside')
subplot(1,2,2)
w_2d_image(w, var2);
f_axis_tight(f);
caxis([35 46])
colorbar('northoutside')


