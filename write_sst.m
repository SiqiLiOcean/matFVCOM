%==========================================================================
% Write FVCOM SST input NetCDF file.
% 
% Input  : 
%   --- fsst, sst file
%   --- x, 
%   --- y,
%   --- time, matlab format
%   --- sst,
%
% Output : \
% 
% Usage  : write_sst(fsst, x, y, time, sst)
%
%
% v1.0
%
% Siqi Li
% 2021-09-21
%
% Updates:
%
%==========================================================================
function write_sst(fsst, x, y, time, sst, varargin)

varargin = read_varargin(varargin, {'Coordinate'}, {'xy'});
Ideal = read_varargin2(varargin, {'Ideal'});

node = length(x);
nt = length(time);

[time, Itime, Itime2, Times] = convert_fvcom_time(time, Ideal);


% create the output file.
ncid = netcdf.create(fsst, 'CLOBBER');

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

% sst
sst_varid = netcdf.defVar(ncid, 'sst', 'float', [node_dimid time_dimid]);
netcdf.putAtt(ncid, sst_varid, 'long_name', 'Sea Surface Temperature');
netcdf.putAtt(ncid, sst_varid, 'units', 'degree C');

% Global attribute
netcdf.putAtt(ncid, -1, 'source', 'FVCOM grid (unstructured) surface forcing');

%end define mode
netcdf.endDef(ncid);

%put data in the output file
netcdf.putVar(ncid, x_varid, x);
netcdf.putVar(ncid, y_varid, y);
for it = 1 : nt
    netcdf.putVar(ncid, time_varid, it-1, 1, time(it));
    netcdf.putVar(ncid, Itime_varid, it-1, 1, Itime(it));
    netcdf.putVar(ncid, Itime2_varid, it-1, 1, Itime2(it));
    if isempty(Ideal)
        netcdf.putVar(ncid, Times_varid, [0 it-1], [26 1], Times(it,:));
    end
    netcdf.putVar(ncid, sst_varid, [0 it-1], [node 1], sst(:,it));
end

% close NC file
netcdf.close(ncid)
