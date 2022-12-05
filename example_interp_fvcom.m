%==========================================================================
% matFVCOM toolbox
%
% example: Draw 2d figures
%       --- f_interp_node2cell
%       --- f_interp_cell2node
%       --- f_interp_level2layer
%       --- f_interp_layer2level
%
% Siqi Li, SMAST
% 2021-03-22
%==========================================================================

clc
clear

%--------------------------------------------------------------------------
% Input file path and name
file = 'H:\tools\matFVCOM\data\gom3_example.nc';

fgrid = f_load_grid(file, 'xy');

temp = ncread(file, 'temp');
u = ncread(file, 'u');
omega = ncread(file, 'omega');


% Interpolate temperature from node to cell
temp2 = f_interp_node2cell(fgrid, temp);
disp(['temp  size: ' num2str(size(temp))])
disp(['temp2 size: ' num2str(size(temp2))])
figure
subplot(1,2,1)
f_2d_image(fgrid, temp(:,1));
subplot(1,2,2)
f_2d_image(fgrid, temp2(:,1));

% Interpolate u from cell to node
u2 = f_interp_cell2node(fgrid, u);
disp(['u  size: ' num2str(size(u))])
disp(['u2 size: ' num2str(size(u2))])
figure
subplot(1,2,1)
f_2d_image(fgrid, u(:,1));
subplot(1,2,2)
f_2d_image(fgrid, u2(:,1));

% Interpolate temperature from siglay to siglev
temp3 = f_interp_layer2level(fgrid, temp);
disp(['temp  size: ' num2str(size(temp))])
disp(['temp3 size: ' num2str(size(temp3))])
figure
subplot(1,2,1)
f_2d_image(fgrid, temp(:,1));
subplot(1,2,2)
f_2d_image(fgrid, temp3(:,1));

% Interpolate omega from siglev to siglay
omega2 = f_interp_level2layer(fgrid, omega);
disp(['omega  size: ' num2str(size(omega))])
disp(['omega2 size: ' num2str(size(omega2))])
figure
subplot(1,2,1)
f_2d_image(fgrid, (omega(:,1)+omega(:,2))/2);
% f_2d_image(fgrid, omega(:,2));
subplot(1,2,2)
f_2d_image(fgrid, omega2(:,1));
