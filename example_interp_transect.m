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
zlim = [-150 0]; 
%--------------------------------------------------------------------------
% Input file path and name
file = 'H:\tools\matFVCOM\data\gom3_example.nc';

%--------------------------------------------------------------------------
% Read the grid and data from input
f = f_load_grid(file, 'geo');
temp = ncread(file, 'temp', [1 1 1], [Inf Inf 1]);


% Method 1: Directly do the interpolation on the section
[dd, zz, var2] = interp_transect(f.x, f.y, f.deplay, temp, xy(:,1), xy(:,2), zlim);

figure
h = pcolor(dd,zz,var2);
set(h, 'linestyle', 'none')

% Method 2: Calculate the weight and then do the interpolation
[dd, zz, weight] = interp_transect_calc_weight(f.x, f.y, f.deplay, xy(:,1), xy(:,2), zlim);
var2 = interp_transect_via_weight(temp, weight);

figure
h = pcolor(dd,zz,var2);
set(h, 'linestyle', 'none')