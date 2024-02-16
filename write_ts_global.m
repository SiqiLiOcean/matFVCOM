%==========================================================================
% Write FVCOM TS DA input data (for Global-FVCOM)
%
% input  :
%   fout  --- output
%   time1 --- starting year and month ('yyyymm')
%   time2 --- ending year and month ('yyyymm')
%   t0    --- temperature, in size of (node, kbm1, nt)
%   s0    --- temperature, in size of (node, kbm1, nt)
%
% output :
%   \
%
% Siqi Li, SMAST
% 2024-02-15
%
% Updates:
%==========================================================================
function write_ts_global(fout, time1, time2, t0, s0, varargin)

varargin = read_varargin2(varargin, {'Ideal'});
varargin = read_varargin2(varargin, {'Loop'});

year1 = str2num(time1(1:4));
month1 = str2num(time1(5:6));
time1 = datenum(year1,month1,1);
year2 = str2num(time2(1:4));
month2 = str2num(time2(5:6));
time2 = datenum(year2,month2,1);

im = month1;
time = mean(datenum(year1,im:im+1,1));
while time(end) < time2
    im = im + 1;
    time = [time mean(datenum(year1,im:im+1,1))];
end

if length(time) ~= size(t0, 3)
    error('The temeprature is in a wrong size')
end
if length(time) ~= size(s0, 3)
    error('The salinity is in a wrong size')
end
node = size(t0, 1);
kbm1 = size(t0, 2);

if ~isempty(Loop)
    t0 = t0(:,:,[end 1:end 1]);
    s0 = s0(:,:,[end 1:end 1]);
    time_before = mean(datenum(year1,month1-1:month1,1));
    if time_before+20 > time(1)
        time_before = time(1) - 31;
    end
    time_after = mean(datenum(year1,month2+1:month2+2,1));
    time = [time_before time time_after];
end

nt = length(time);
[time, Itime, Itime2, Times] = convert_fvcom_time(time, Ideal);


% Create the nesting file
ncid = netcdf.create(fout, 'CLOBBER');

% Define global attributes
netcdf.putAtt(ncid, -1, 'source', 'FVCOM river input');

% Define dimensions
time_dimid = netcdf.defDim(ncid, 'time', 0);
node_dimid = netcdf.defDim(ncid, 'node', node);
siglay_dimid = netcdf.defDim(ncid, 'siglay', kbm1);
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

temperature_varid = netcdf.defVar(ncid, 'temp_clim', 'float', [node_dimid siglay_dimid time_dimid]);
netcdf.putAtt(ncid, temperature_varid, 'long_name', 'temperature');
netcdf.putAtt(ncid, temperature_varid, 'units', 'degree_C');

salinity_varid = netcdf.defVar(ncid, 'salinity_clim', 'float', [node_dimid siglay_dimid time_dimid]);
netcdf.putAtt(ncid, salinity_varid, 'long_name', 'salinity');
netcdf.putAtt(ncid, salinity_varid, 'units', 'psu');

% End define mode
netcdf.endDef(ncid);

% Write data
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
    netcdf.putVar(ncid, temperature_varid, [0 0 it-1], [node siglay 1], t0(:,:,it));
    netcdf.putVar(ncid, salinity_varid, [0 0 it-1], [node siglay 1], s0(:,:,it));
end

% Close the nesting file
netcdf.close(ncid);

end