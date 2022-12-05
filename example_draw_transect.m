%==========================================================================
% matFVCOM toolbox
%
% example: Draw transect figures
%       --- f_load_grid
%       --- f_transect_mesh
%       --- f_transect_image
%       --- f_transect_contour
%       --- f_transect_mask_bottom
%
% Siqi Li, SMAST
% 2021-03-22
%==========================================================================

clc
clear

%--------------------------------------------------------------------------
% The location of the section. Only the turning pionts are needed.
xy=[-70.88333333	41.19666667     % L1
     -70.88333333	41.03000000     % L2
     -70.88333333	40.86333333     % L3
     -70.88333333	40.69666667     % L4
     -70.88333333	40.51333333     % L5
     -70.88333333	40.36333333     % L6
     -70.88333333	40.22666667     % L7
     -70.88333333	40.09833333     % L9
     -70.88333333	39.94000000     % L10
     -70.88333333	39.77333333     % L11
    ];
station_list = {'L1';'L2';'L3';'L4';'L5';'L6';'L7';'L9';'L10';'L11';};
zlims = [-500 0]; 
d0 = sqrt((xy(:,1)-xy(1,1)).^2+(xy(:,2)-xy(1,2)).^2);

%--------------------------------------------------------------------------
% Input file path and name
file = 'H:\tools\matFVCOM\data\gom3_example.nc';

%--------------------------------------------------------------------------
% Draw FVCOM transect mesh figure (layer and level)
f = f_load_grid(file, 'geo');

figure
hold on
h1 = f_transect_mask_bottom(f, xy(:,1), xy(:,2), zlims);
h2 = f_transect_mesh(f, 'layer', xy(:,1), xy(:,2), zlims, 'linestyle', '--');
h3 = f_transect_mesh(f, 'level', xy(:,1), xy(:,2), zlims, 'linestyle', '-');
set(gca, 'xtick', d0)
set(gca, 'xticklabel', {'L1';'L2';'L3';'L4';'L5';'L6';'L7';'L9';'L10';'L11';})


%--------------------------------------------------------------------------
% Draw FVCOM transect image figure: temperature (on node) 
temp = ncread(file, 'temp', [1 1 1], [Inf Inf 1]);


figure
colormap(jet)
hold on
h1 = f_transect_image(f, temp, xy(:,1), xy(:,2), zlims);
colorbar
h2 = f_transect_mask_bottom(f, xy(:,1), xy(:,2), zlims);
set(gca, 'xtick', d0)
set(gca, 'xticklabel', station_list)


%--------------------------------------------------------------------------
% Draw FVCOM transect image figure: temperature (on cell) 
u = ncread(file, 'u', [1 1 1], [Inf Inf 1]);

figure
hold on
h1 = f_transect_image(f, u, xy(:,1), xy(:,2), zlims);
colorbar
h2 = f_transect_contour(f, u, xy(:,1), xy(:,2), zlims);
h3 = f_transect_mask_bottom(f, xy(:,1), xy(:,2), zlims);
set(gca, 'xtick', d0)
set(gca, 'xticklabel', station_list)

