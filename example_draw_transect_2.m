clc
clear

addpath('./matfvcom');

% Input file
fin = './gom3_h_coupling.nc';

% section x and y
x0 = [535302.343849785 566956.492256008 634643.662066818 825728.324048087];
y0 = [-372720.068270023 -440901.788215543 -499034.493345650 -658445.305812546];  

% lower and upper depth
zlims = [-400 0];


f = f_load_grid(fin, 'xy');
temp = ncread(fin, 'temp');


% Interpolation
[dd, zz, tt] = interp_transect(f.x, f.y, f.deplay, temp, x0, y0, zlims);



hold on
h = pcolor(dd, zz, tt);
set(h, 'linestyle', 'none')
contour(dd, zz, tt, 'color', 'k');

