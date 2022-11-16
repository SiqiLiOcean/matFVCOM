%==========================================================================
% Write the FVCOM-SWAVE nesting forcing input file
%
% input  :
%   fout --- the NetCDF output
%   fn   --- the fgrid of nesting boundary
%   (Variables below can be writen in to a random order (except Time).)
%   Variable name | Description             | size       | unit 
%   Time            time                      (nt)         datenum format
%   hs              Significant Wave Height   (node, nt)   m
%   tpeak           Relative Peak Period      (node, nt)   s
%   wdir            Wave Direction            (node, nt)   degree
% 
% output :
%
% Siqi Li, SMAST
% 2022-10-05
%
% Updates:
%
%==========================================================================
function write_nesting_wave(fout, fn, varargin)



varargin = read_varargin(varargin, {'Time'}, {[]});
varargin = read_varargin(varargin, {'Hs'}, {[]});
varargin = read_varargin(varargin, {'Tpeak'}, {[]});
varargin = read_varargin(varargin, {'Wdir'}, {[]});


% w_nesting_node = interp_2d_calc_weight('ID', f1.x, f1.y, f2.x(nesting_node), f2.y(nesting_node));
% w_nesting_cell = interp_2d_calc_weight('ID', f1.x, f1.y, f2.x(nesting_cell), f2.y(nesting_cell));


if isempty(Time)
    error('There should be at least one time.')
else
    nt = length(Time);
    [time, Itime, Itime2, Times] = convert_fvcom_time(Time);
%     Times = datestr(Time, 'yyyy-mm-ddTHH:MM:SS.000000');
%     time = Time - datenum(1858, 11, 17);
%     Itime = floor(time);
%     Itime2 = (time - Itime)*24*3600 * 1000;
end


% Create the nesting file
ncid = netcdf.create(fout, 'CLOBBER');

% Define global attributes
netcdf.putAtt(ncid, -1, 'source', 'FVCOM');
netcdf.putAtt(ncid, -1, 'CoordinateSystem', 'Cartesian');

% Define dimensions
time_dimid = netcdf.defDim(ncid, 'time', 0);
node_dimid = netcdf.defDim(ncid, 'node', fn.node);
nele_dimid = netcdf.defDim(ncid, 'nele', fn.nele);
siglay_dimid = netcdf.defDim(ncid, 'siglay', fn.kbm1);
siglev_dimid = netcdf.defDim(ncid, 'siglev', fn.kb);
three_dimid = netcdf.defDim(ncid, 'three', 3);
DateStrLen_dimid = netcdf.defDim(ncid, 'DateStrLen', 26);

% Define variables
% x
x_varid = netcdf.defVar(ncid, 'x', 'float', node_dimid);
netcdf.putAtt(ncid, x_varid, 'long_name', 'nodal x-coordinate');
netcdf.putAtt(ncid, x_varid, 'units', 'm');
% y
y_varid = netcdf.defVar(ncid, 'y', 'float', node_dimid);
netcdf.putAtt(ncid, y_varid, 'long_name', 'nodal y-coordinate');
netcdf.putAtt(ncid, y_varid, 'units', 'm');
% xc
xc_varid = netcdf.defVar(ncid, 'xc', 'float', nele_dimid);
netcdf.putAtt(ncid, xc_varid, 'long_name', 'zonal x-coordinate');
netcdf.putAtt(ncid, xc_varid, 'units', 'm');
% yc
yc_varid = netcdf.defVar(ncid, 'yc', 'float', nele_dimid);
netcdf.putAtt(ncid, yc_varid, 'long_name', 'zonal y-coordinate');
netcdf.putAtt(ncid, yc_varid, 'units', 'm');
% nv
nv_varid = netcdf.defVar(ncid, 'nv', 'int', [nele_dimid three_dimid]);
netcdf.putAtt(ncid, nv_varid, 'long_name', 'znodes surrounding element');
% lon
lon_varid = netcdf.defVar(ncid, 'lon', 'float', node_dimid);
netcdf.putAtt(ncid, lon_varid, 'long_name', 'nodal longitude');
netcdf.putAtt(ncid, lon_varid, 'units', 'degree_east');
% lat
lat_varid = netcdf.defVar(ncid, 'lat', 'float', node_dimid);
netcdf.putAtt(ncid, lat_varid, 'long_name', 'nodal latgitude');
netcdf.putAtt(ncid, lat_varid, 'units', 'degree_north');
% lonc
lonc_varid = netcdf.defVar(ncid, 'lonc', 'float', nele_dimid);
netcdf.putAtt(ncid, lonc_varid, 'long_name', 'zonal longitude');
netcdf.putAtt(ncid, lonc_varid, 'units', 'degree_east');
% latc
latc_varid = netcdf.defVar(ncid, 'latc', 'float', nele_dimid);
netcdf.putAtt(ncid, latc_varid, 'long_name', 'zonal latgitude');
netcdf.putAtt(ncid, latc_varid, 'units', 'degree_north');
% siglay
siglay_varid = netcdf.defVar(ncid, 'siglay', 'float', [node_dimid siglay_dimid]);
netcdf.putAtt(ncid, siglay_varid, 'long_name', 'Sigma Layers');
% siglev
siglev_varid = netcdf.defVar(ncid, 'siglev', 'float', [node_dimid siglev_dimid]);
netcdf.putAtt(ncid, siglev_varid, 'long_name', 'Sigma Levels');
% siglay_center
siglay_center_varid = netcdf.defVar(ncid, 'siglay_center', 'float', [nele_dimid,siglay_dimid]);
netcdf.putAtt(ncid, siglay_center_varid, 'long_name', 'Sigma Layers');
% siglev_center
siglev_center_varid = netcdf.defVar(ncid, 'siglev_center', 'float', [nele_dimid,siglev_dimid]);
netcdf.putAtt(ncid, siglev_center_varid, 'long_name', 'Sigma Levels');
% h
h_varid = netcdf.defVar(ncid, 'h', 'float', node_dimid);
netcdf.putAtt(ncid, h_varid, 'long_name', 'Bathymetry');
netcdf.putAtt(ncid, h_varid, 'units', 'm');
% h_center
h_center_varid = netcdf.defVar(ncid, 'h_center', 'float', nele_dimid);
netcdf.putAtt(ncid, h_center_varid, 'long_name', 'Bathymetry');
netcdf.putAtt(ncid, h_center_varid, 'units', 'm');
% time
time_varid = netcdf.defVar(ncid, 'time', 'float', time_dimid);
netcdf.putAtt(ncid, time_varid, 'units', 'days since 1858-11-17 00:00:00');
netcdf.putAtt(ncid, time_varid, 'format', 'modified julian day (MJD)');
netcdf.putAtt(ncid, time_varid, 'time_zone', 'UTC');
% Itime
Itime_varid = netcdf.defVar(ncid, 'Itime', 'int', time_dimid);
netcdf.putAtt(ncid, Itime_varid, 'units', 'days since 1858-11-17 00:00:00');
netcdf.putAtt(ncid, Itime_varid, 'format', 'modified julian day (MJD)');
netcdf.putAtt(ncid, Itime_varid, 'time_zone', 'UTC');
% Itime2
Itime2_varid = netcdf.defVar(ncid, 'Itime2', 'int', time_dimid);
netcdf.putAtt(ncid, Itime2_varid, 'units', 'msec since 00:00:00');
netcdf.putAtt(ncid, Itime2_varid, 'time_zone', 'UTC');
% Times
Times_varid = netcdf.defVar(ncid, 'Times', 'char', [DateStrLen_dimid time_dimid]);
netcdf.putAtt(ncid, Times_varid, 'format', 'yyyy-mm-ddTHH:MM:SS.000000');
netcdf.putAtt(ncid, Times_varid, 'time_zone', 'UTC');
if ~isempty(Hs)
    % Hs
    Hs_varid = netcdf.defVar(ncid, 'hs', 'float', [node_dimid time_dimid]);
    netcdf.putAtt(ncid, Hs_varid, 'long_name', 'Significant Wave Height');
    netcdf.putAtt(ncid, Hs_varid, 'units', 'm');
end
if ~isempty(Tpeak)
    % Tpeak
    Tpeak_varid = netcdf.defVar(ncid, 'Tpeak', 'float', [node_dimid time_dimid]);
    netcdf.putAtt(ncid, Tpeak_varid, 'long_name', 'Relative Peak Period');
    netcdf.putAtt(ncid, Tpeak_varid, 'units', 's');
end
if ~isempty(Wdir)
    % Wdir
    Wdir_varid = netcdf.defVar(ncid, 'Wdir', 'float', [node_dimid time_dimid]);
    netcdf.putAtt(ncid, Wdir_varid, 'long_name', 'Wave Direction');
    netcdf.putAtt(ncid, Wdir_varid, 'units', 'degree');
end

% End define mode
netcdf.endDef(ncid);

% Write data
netcdf.putVar(ncid, x_varid, fn.x);
netcdf.putVar(ncid, y_varid, fn.y);
netcdf.putVar(ncid, xc_varid, fn.xc);
netcdf.putVar(ncid, yc_varid, fn.yc);
netcdf.putVar(ncid, nv_varid, fn.nv);
netcdf.putVar(ncid, h_varid, fn.h);
netcdf.putVar(ncid, lon_varid, fn.LON);
netcdf.putVar(ncid, lat_varid, fn.LAT);
netcdf.putVar(ncid, lonc_varid, mean(fn.LON(fn.nv), 2));
netcdf.putVar(ncid, latc_varid, mean(fn.LAT(fn.nv), 2));
netcdf.putVar(ncid, siglay_varid, fn.siglay);
netcdf.putVar(ncid, siglev_varid, fn.siglev);
netcdf.putVar(ncid, h_center_varid, fn.hc);
netcdf.putVar(ncid, siglay_center_varid, fn.siglayc);
netcdf.putVar(ncid, siglev_center_varid, fn.siglevc);
for it = 1 : nt
    disp(['---Writing data for time: ' Times(it, :)])
    netcdf.putVar(ncid, time_varid, it-1, 1, time(it));
    netcdf.putVar(ncid, Itime_varid, it-1, 1, Itime(it));
    netcdf.putVar(ncid, Itime2_varid, it-1, 1, Itime2(it));
    netcdf.putVar(ncid, Times_varid, [0 it-1], [length(Times(it,:)) 1], Times(it,:));
    if ~isempty(Hs)
        netcdf.putVar(ncid, Hs_varid, [0 it-1], [fn.node 1], Hs(:, it));
    end
    if ~isempty(Tpeak)
        netcdf.putVar(ncid, Tpeak_varid, [0 it-1], [fn.node 1], Tpeak(:, it));
    end
    if ~isempty(Wdir)
        netcdf.putVar(ncid, Wdir_varid, [0 it-1], [fn.node 1], Wdir(:, it));
    end    
end
% Close the nesting file
netcdf.close(ncid);


