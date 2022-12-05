addpath('~/../siqili/tools/matFVCOM/')

clc
clear


%------------------------------------------
% Input restart file
fin = '/hosts/hydra.smast.umassd.edu/data3/c1chen/Typhoon_Hato/output/cns_hot_restart_0001.nc';
% Output TS initial file
fout = 'initfile_20170817.nc';
% Selected date
date_ini = datenum(2017, 8, 17, 0, 0, 0);
% Standard depth list
std = [0:5:95 100:25:475 500:50:1950 2000:100:5500];
%------------------------------------------



% Find the time index
disp('---------Find the time index')
date_restart = ncread(fin, 'time');
% date_restart = [57975, 57976, 57977, 57978, 57979, 57980, 57981, 57982, 57983, 57984, 57985, 57986, 57987, 57988, 57989, 57990, 57991, 57992, 57993, 57994, 57995, 57996];
date_restart = date_restart + datenum(1858, 11, 17, 0, 0, 0);
it = find(date_restart == date_ini);

% Read the data
disp('---------Read the data from the input file')
f = f_load_grid(fin, 'Coordinate', 'Geo');
temp = ncread(fin, 'temp', [1 1 it], [Inf Inf 1]);
salinity = ncread(fin, 'salinity', [1 1 it], [Inf Inf 1]);

% Interpolation
disp('---------Interpolation')
tsl = interp_vertical(f.deplay, temp, repmat(std, f.node, 1));
ssl = interp_vertical(f.deplay, salinity, repmat(std, f.node, 1));

% Write out the data to output.
disp('---------Write the data into the output file')
write_initial_ts(fout, -std, tsl, ssl, datevec(date_ini));

