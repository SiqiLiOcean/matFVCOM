%==========================================================================
% Write FVCOM SSS input NetCDF file.
% 
% Input  : 
%   --- fsss, sss file
%   --- x, 
%   --- y,
%   --- time, matlab format
%   --- sss,
%
% Output : \
% 
% Usage  : write_sss(fsss, x, y, time, sss)
%
%
% v1.0
%
% Siqi Li
% 2023-01-30
%
% Updates:
% 2023-04-25  Added weights. 
%==========================================================================
function write_sss(fsss, x, y, time, sss, varargin)

varargin = read_varargin(varargin, {'Coordinate'}, {'xy'});
varargin = read_varargin(varargin, {'Weight'}, {1});
varargin = read_varargin2(varargin, {'Ideal'});

node = length(x);
nt = length(time);

if numel(Weight) == 1
    Weight = ones(node,1) * Weight;
end

[time, Itime, Itime2, Times] = convert_fvcom_time(time, Ideal);

% create the output file.
ncid = netcdf.create(fsss, 'CLOBBER');

%define the dimension
node_dimid = netcdf.defDim(ncid, 'node', node);
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

% sss
sss_varid = netcdf.defVar(ncid, 'sss', 'float', [node_dimid time_dimid]);
netcdf.putAtt(ncid, sss_varid, 'long_name', 'Sea Surface Salinity');
netcdf.putAtt(ncid, sss_varid, 'units', 'PSU');

% Weight
weight_varid = netcdf.defVar(ncid, 'weight', 'float', node_dimid);
netcdf.putAtt(ncid, weight_varid, 'long_name', 'Sea Surface Salinity weight');
netcdf.putAtt(ncid, weight_varid, 'units', '1');


% Global attribute
netcdf.putAtt(ncid, -1, 'source', 'FVCOM grid (unstructured) surface forcing');

%end define mode
netcdf.endDef(ncid);

%put data in the output file
netcdf.putVar(ncid, x_varid, x);
netcdf.putVar(ncid, y_varid, y);
netcdf.putVar(ncid, weight_varid, Weight);
for it = 1 : nt
    netcdf.putVar(ncid, time_varid, it-1, 1, time(it));
    netcdf.putVar(ncid, Itime_varid, it-1, 1, Itime(it));
    netcdf.putVar(ncid, Itime2_varid, it-1, 1, Itime2(it));
    if isempty(Ideal)
        netcdf.putVar(ncid, Times_varid, [0 it-1], [26 1], Times(it,:));
    end
    netcdf.putVar(ncid, sss_varid, [0 it-1], [node 1], sss(:,it));
end

% close NC file
netcdf.close(ncid)
