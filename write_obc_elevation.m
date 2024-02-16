%==========================================================================
% Write the FVCOM OBC elevation input file
%
% input  :
%   fout --- the NetCDF output
%
%
% output :
%
% Siqi Li, SMAST
% 2024-02-13
%==========================================================================
function write_obc_elevation(fout, obc_node, time, obc_elevation, varargin)

varargin = read_varargin2(varargin, {'Ideal'});

nobc = length(obc_node);

nt = length(time);
[time, Itime, Itime2, Times] = convert_fvcom_time(time, Ideal);

% Create the nesting file
ncid = netcdf.create(fout, 'CLOBBER');

% Define global attributes
netcdf.putAtt(ncid, -1, 'source', 'FVCOM OBC elevation input');
netcdf.putAtt(ncid, -1, 'type', 'FVCOM TIME SERIES ELEVATION FORCING FILE');



% Define dimensions
time_dimid = netcdf.defDim(ncid, 'time', 0);
nobc_dimid = netcdf.defDim(ncid, 'nobc', nobc);
DateStrLen_dimid = netcdf.defDim(ncid, 'DateStrLen', 26);

% Define variables
if ~isempty(Ideal)
    % time
    time_varid = netcdf.defVar(ncid,'time', 'float', time_dimid);
    netcdf.putAtt(ncid, time_varid, 'long_name', 'time');
    netcdf.putAtt(ncid, time_varid, 'units', 'days since 0.0');
    netcdf.putAtt(ncid, time_varid, 'time_zone', 'none');
    % Itime
    Itime_varid = netcdf.defVar(ncid, 'Itime', 'int', time_dimid);
    netcdf.putAtt(ncid, time_varid, 'units', 'days since 0.0');
    netcdf.putAtt(ncid, Itime_varid, 'time_zone', 'none');
    % Itime2
    Itime2_varid = netcdf.defVar(ncid, 'Itime2', 'int', time_dimid);
    netcdf.putAtt(ncid, Itime2_varid, 'units', 'msec since 00:00:00');
    netcdf.putAtt(ncid, Itime2_varid, 'time_zone', 'none');
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
% nobc_nodes
obc_nodes_varid = netcdf.defVar(ncid, 'obc_nodes', 'int', nobc_dimid);
netcdf.putAtt(ncid, obc_nodes_varid, 'long_name', 'Open Boundary Node Number');
netcdf.putAtt(ncid, obc_nodes_varid, 'grid', 'obc_grid');
% elevation
elevation_varid = netcdf.defVar(ncid, 'elevation', 'float', [nobc_dimid time_dimid]);
netcdf.putAtt(ncid, elevation_varid, 'long_name', 'Open Bounday Elevation');
netcdf.putAtt(ncid, elevation_varid, 'units', 'meters');

% End define mode
netcdf.endDef(ncid);

% Write data
netcdf.putVar(ncid, obc_nodes_varid, obc_node);
for it = 1 : nt
    if mod(it, 10) == 1
        disp(['---Writing data for time: ' Times(it, :)])
    end
    netcdf.putVar(ncid, time_varid, it-1, 1, time(it));
    netcdf.putVar(ncid, Itime_varid, it-1, 1, Itime(it));
    netcdf.putVar(ncid, Itime2_varid, it-1, 1, Itime2(it));
    if isempty(Ideal)
        netcdf.putVar(ncid, Times_varid, [0 it-1], [length(Times(it,:)) 1], Times(it,:));
    end
end
for it = 1 : nt
    netcdf.putVar(ncid, elevation_varid, [0 it-1], [nobc 1], obc_elevation(:,it));
end

% Close the nesting file
netcdf.close(ncid);


