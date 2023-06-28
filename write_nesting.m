%==========================================================================
% Write the FVCOM nesting forcing input file
%
% input  :
%   fout --- the NetCDF output
%   fn   --- the fgrid of nesting boundary
%   (Variables below can be writen in to a random order (except Time).)
%   Variable name | Description       | size               | unit 
%   Time            time                (nt)                 datenum format
%   Zeta            surface elevation   (node, nt)           m
%   Temperature     water temperature   (node, siglay, nt)   degree C
%   Salinity        water salinity      (node, siglay, nt)   psu
%   U               x-velocity          (nele, siglay, nt)   m/s
%   V               y-velocity          (nele, siglay, nt)   m/s
%   Hyw             z-velocity          (node, siglev, nt)   m/s
%   weight_node     weight on node      (node, nt)           1
%   weight_cell     weight on cell      (nele, nt)           1
% 
% output :
%
% Siqi Li, SMAST
% 2022-09-21
%
% Updates:
%
%==========================================================================
function write_nesting(fout, fn, varargin)

varargin = read_varargin2(varargin, {'Ideal'});

varargin = read_varargin(varargin, {'Time'}, {[]});
varargin = read_varargin(varargin, {'Zeta'}, {[]});
varargin = read_varargin(varargin, {'Temperature'}, {[]});
varargin = read_varargin(varargin, {'Salinity'}, {[]});
varargin = read_varargin(varargin, {'U'}, {[]});
varargin = read_varargin(varargin, {'V'}, {[]});
varargin = read_varargin(varargin, {'Ua'}, {[]});
varargin = read_varargin(varargin, {'Va'}, {[]});
varargin = read_varargin(varargin, {'Hyw'}, {[]});
varargin = read_varargin(varargin, {'Weight_node'}, {[]});
varargin = read_varargin(varargin, {'Weight_cell'}, {[]});




% w_nesting_node = interp_2d_calc_weight('ID', f1.x, f1.y, f2.x(nesting_node), f2.y(nesting_node));
% w_nesting_cell = interp_2d_calc_weight('ID', f1.x, f1.y, f2.x(nesting_cell), f2.y(nesting_cell));


if isempty(Time)
    error('There should be at least one time.')
else
    nt = length(Time);
    [time, Itime, Itime2, Times] = convert_fvcom_time(Time, Ideal);
%     Times = datestr(Time, 'yyyy-mm-ddTHH:MM:SS.000000');
%     time = Time - datenum(1858, 11, 17);
%     Itime = floor(time);
%     Itime2 = (time - Itime)*24*3600 * 1000;
end

if length(Weight_node(:)) == fn.node
    Weight_node = repmat(Weight_node(:), 1, nt);
end
if length(Weight_cell(:)) == fn.nele
    Weight_cell = repmat(Weight_cell(:), 1, nt);
end

dzc = -diff(fn.siglevc, 1, 2);
if isempty(Ua) && ~isempty(U)
    for it = 1 : nt
        Ua(:,it) = sum(U(:,:,it).*dzc, 2);
    end
end
if isempty(Va) && ~isempty(V)
    for it = 1 : nt
        Va(:,it) = sum(V(:,:,it).*dzc, 2);
    end
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
% hc
hc_varid = netcdf.defVar(ncid, 'hc', 'float', nele_dimid);
netcdf.putAtt(ncid, hc_varid, 'long_name', 'Bathymetry');
netcdf.putAtt(ncid, hc_varid, 'units', 'm');
% h_center
h_center_varid = netcdf.defVar(ncid, 'h_center', 'float', nele_dimid);
netcdf.putAtt(ncid, h_center_varid, 'long_name', 'Bathymetry');
netcdf.putAtt(ncid, h_center_varid, 'units', 'm');
if ~isempty(Ideal)
    % time
    time_varid = netcdf.defVar(ncid,'time', 'float', time_dimid);
    netcdf.putAtt(ncid, time_varid, 'long_name', 'time');
    netcdf.putAtt(ncid, time_varid, 'units', 'days since 0.0');
    netcdf.putAtt(ncid, time_varid, 'time_zone', 'UTC');
    % Itime
    Itime_varid = netcdf.defVar(ncid, 'Itime', 'int', time_dimid);
    netcdf.putAtt(ncid, time_varid, 'units', 'days since 0.0');
    netcdf.putAtt(ncid, Itime_varid, 'time_zone', 'UTC');
    % Itime2
    Itime2_varid = netcdf.defVar(ncid, 'Itime2', 'int', time_dimid);
    netcdf.putAtt(ncid, Itime2_varid, 'units', 'msec since 00:00:00');
    netcdf.putAtt(ncid, Itime2_varid, 'time_zone', 'UTC');
else
    % time
    time_varid = netcdf.defVar(ncid,'time', 'float', time_dimid);
    netcdf.putAtt(ncid, time_varid, 'long_name', 'time');
    netcdf.putAtt(ncid, time_varid, 'unit', 'days since 1858-11-17 00:00:00');
    netcdf.putAtt(ncid, time_varid, 'format', 'modified julian dat (MJD)');
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
    netcdf.putAtt(ncid, Times_varid, 'time_zone', 'UTC');
end
if ~isempty(Zeta)
    % zeta
    zeta_varid = netcdf.defVar(ncid, 'zeta', 'float', [node_dimid time_dimid]);
    netcdf.putAtt(ncid, zeta_varid, 'long_name', 'Water Surface Elevation');
    netcdf.putAtt(ncid, zeta_varid, 'units', 'm');
end
if ~isempty(U)
    % u
    u_varid = netcdf.defVar(ncid, 'u', 'float', [nele_dimid siglay_dimid time_dimid]);
    netcdf.putAtt(ncid, u_varid, 'long_name', 'Eastward Water Velocity');
    netcdf.putAtt(ncid, u_varid, 'units', 'm/s');
end
if ~isempty(Ua)
    % ua
    ua_varid = netcdf.defVar(ncid, 'ua', 'float', [nele_dimid time_dimid]);
    netcdf.putAtt(ncid, ua_varid, 'long_name', 'Vertically Averaged x-velocity');
    netcdf.putAtt(ncid, ua_varid, 'units', 'm/s');
end
if ~isempty(V)
    % v
    v_varid = netcdf.defVar(ncid, 'v', 'float', [nele_dimid siglay_dimid time_dimid]);
    netcdf.putAtt(ncid, v_varid, 'long_name', 'Northward Water Velocity');
    netcdf.putAtt(ncid, v_varid, 'units', 'm/s');
end
if ~isempty(Va)
    % va
    va_varid = netcdf.defVar(ncid, 'va', 'float', [nele_dimid time_dimid]);
    netcdf.putAtt(ncid, va_varid, 'long_name', 'Vertically Averaged y-velocity');
    netcdf.putAtt(ncid, va_varid, 'units', 'm/s');
end
if ~isempty(Temperature)
    % temperature
    temp_varid = netcdf.defVar(ncid, 'temp', 'float', [node_dimid siglay_dimid time_dimid]);
    netcdf.putAtt(ncid, temp_varid, 'long_name', 'temperature');
    netcdf.putAtt(ncid, temp_varid, 'units', 'degrees_C');
end
if ~isempty(Salinity)
    % salinity
    salinity_varid = netcdf.defVar(ncid, 'salinity', 'float', [node_dimid siglay_dimid time_dimid]);
    netcdf.putAtt(ncid, salinity_varid, 'long_name', 'salinity');
    netcdf.putAtt(ncid, salinity_varid, 'units', '1e-3');
end
if ~isempty(Hyw)
    % hyw
    hyw_varid = netcdf.defVar(ncid, 'hyw', 'float', [node_dimid siglev_dimid time_dimid]);
    netcdf.putAtt(ncid, hyw_varid, 'long_name', 'hydrostatic vertical velocity');
    netcdf.putAtt(ncid, hyw_varid, 'units', 'm/s');
end
if ~isempty(Weight_node)
    % Weight_node
    weight_node_varid = netcdf.defVar(ncid, 'weight_node', 'float', [node_dimid time_dimid]);
    netcdf.putAtt(ncid, weight_node_varid, 'long_name', 'Weights for nodes in relaxation zone');
    netcdf.putAtt(ncid, weight_node_varid, 'units', '1');
end
if ~isempty(Weight_cell)
    % Weight_cell
    weight_cell_varid = netcdf.defVar(ncid, 'weight_cell', 'float', [nele_dimid time_dimid]);
    netcdf.putAtt(ncid, weight_cell_varid, 'long_name', 'Weights for elements in relaxation zone');
    netcdf.putAtt(ncid, weight_cell_varid, 'units', '1');
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
    if isempty(Ideal)
        netcdf.putVar(ncid, Times_varid, [0 it-1], [length(Times(it,:)) 1], Times(it,:));
    end
    if ~isempty(Zeta)
        netcdf.putVar(ncid, zeta_varid, [0 it-1], [fn.node 1], Zeta(:, it));
    end
    if ~isempty(Temperature)
        netcdf.putVar(ncid, temp_varid, [0 0 it-1], [fn.node fn.kbm1 1], Temperature(:, :, it));
    end
    if ~isempty(Salinity)
        netcdf.putVar(ncid, salinity_varid, [0 0 it-1], [fn.node fn.kbm1 1], Salinity(:, :, it));
    end    
    if ~isempty(U)
        netcdf.putVar(ncid, u_varid, [0 0 it-1], [fn.nele fn.kbm1 1], U(:, :, it));
        netcdf.putVar(ncid, ua_varid, [0 it-1], [fn.nele 1], Ua(:, it));
    end
    if ~isempty(V)
        netcdf.putVar(ncid, v_varid, [0 0 it-1], [fn.nele fn.kbm1 1], V(:, :, it));
        netcdf.putVar(ncid, va_varid, [0 it-1], [fn.nele 1], Va(:, it));
    end
    if ~isempty(Hyw)
        netcdf.putVar(ncid, hyw_varid, [0 0 it-1], [fn.node fn.kb 1], Hyw(:, :, it));
    end
    if ~isempty(Weight_node)
        netcdf.putVar(ncid, weight_node_varid, [0 it-1], [fn.node 1], Weight_node(:, it));
    end    
    if ~isempty(Weight_cell)
        netcdf.putVar(ncid, weight_cell_varid, [0 it-1], [fn.nele 1], Weight_cell(:, it));
    end    
end
% Close the nesting file
netcdf.close(ncid);


