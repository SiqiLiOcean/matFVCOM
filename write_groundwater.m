%==========================================================================
% Write FVCOM groundwater input NetCDF file.
% 
% Input  : 
%   fgw     --- groundwater file
%   x       --- 
%   y       ---
%   time    --- matlab format
%   flux    --- ground water flux (m3/s)
%   temp    --- ground water temperature (degree C)
%   salinity--- ground water salinity (psu)
%
% Output : \
% 
%
%
% Siqi Li
% 2022-10-26
%
% Updates:
%
%==========================================================================
function write_groundwater(fgw, x, y, nv, time, varargin)

varargin = read_varargin(varargin, {'Coordinate'}, {'xy'});
varargin = read_varargin2(varargin, {'Ideal'});

node = length(x);
nele = size(nv, 1);
nt = length(time);
xc = mean(x(nv), 2);
yc = mean(y(nv), 2);

varargin = read_varargin(varargin, {'Flux'}, {zeros(node,nt)});
varargin = read_varargin(varargin, {'Temperature'}, {zeros(node,nt)});
varargin = read_varargin(varargin, {'Salinity'}, {zeros(node,nt)});

[time, Itime, Itime2, Times] = convert_fvcom_time(time, Ideal);

% create the output file.
ncid = netcdf.create(fgw, 'CLOBBER');

%define the dimension
node_dimid = netcdf.defDim(ncid, 'node', node);
nele_dimid = netcdf.defDim(ncid, 'nele', nele);
time_dimid = netcdf.defDim(ncid, 'time', netcdf.getConstant('NC_UNLIMITED'));
DateStrLen_dimid = netcdf.defDim(ncid, 'DateStrLen', 26);

%define variables
if strcmp(Coordinate, 'Geo')
    % x
    x_varid = netcdf.defVar(ncid, 'lon', 'float', node_dimid);
    netcdf.putAtt(ncid, x_varid, 'long_name', 'nodal longitude');
    netcdf.putAtt(ncid, x_varid, 'units', 'degrees_east');
    % y
    y_varid = netcdf.defVar(ncid, 'lat', 'float', node_dimid);
    netcdf.putAtt(ncid, y_varid, 'long_name', 'nodal latitude');
    netcdf.putAtt(ncid, y_varid, 'units', 'degrees_north');
else
    % x
    x_varid = netcdf.defVar(ncid, 'x', 'float', node_dimid);
    netcdf.putAtt(ncid, x_varid, 'long_name', 'nodal x');
    netcdf.putAtt(ncid, x_varid, 'units', 'meter');
    % y
    y_varid = netcdf.defVar(ncid, 'y', 'float', node_dimid);
    netcdf.putAtt(ncid, y_varid, 'long_name', 'nodal y');
    netcdf.putAtt(ncid, y_varid, 'units', 'meter');
end


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

% Flux
flux_varid = netcdf.defVar(ncid, 'groundwater_flux', 'float', [node_dimid time_dimid]);
netcdf.putAtt(ncid, flux_varid, 'long_name', 'Ground Water Flux');
netcdf.putAtt(ncid, flux_varid, 'units', 'm3 s-1');
% Temperature
temp_varid = netcdf.defVar(ncid, 'groundwater_temp', 'float', [node_dimid time_dimid]);
netcdf.putAtt(ncid, temp_varid, 'long_name', 'Ground Water Temperature');
netcdf.putAtt(ncid, temp_varid, 'units', 'degree C');
% Salinity
salinity_varid = netcdf.defVar(ncid, 'groundwater_salt', 'float', [node_dimid time_dimid]);
netcdf.putAtt(ncid, salinity_varid, 'long_name', 'Ground Water Salinity');
netcdf.putAtt(ncid, salinity_varid, 'units', 'psu');

% Global attribute
netcdf.putAtt(ncid, -1, 'source', 'fvcom grid (unstructured) surface forcing');

%end define mode
netcdf.endDef(ncid);

%put data in the output file
netcdf.putVar(ncid, x_varid, x);
netcdf.putVar(ncid, y_varid, y);
netcdf.putVar(ncid, xc_varid, xc);
netcdf.putVar(ncid, yc_varid, yc);


for it = 1 : nt
    netcdf.putVar(ncid, time_varid, it-1, 1, time(it));
    netcdf.putVar(ncid, Itime_varid, it-1, 1, Itime(it));
    netcdf.putVar(ncid, Itime2_varid, it-1, 1, Itime2(it));
    if isempty(Ideal)
        netcdf.putVar(ncid, Times_varid, [0 it-1], [26 1], Times(it,:));
    end

    netcdf.putVar(ncid, flux_varid, [0 it-1], [node 1], Flux(:,it));
    netcdf.putVar(ncid, temp_varid, [0 it-1], [node 1], Temperature(:,it));
    netcdf.putVar(ncid, salinity_varid, [0 it-1], [node 1], Salinity(:,it));
end

% close NC file
netcdf.close(ncid)
