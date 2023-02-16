%==========================================================================
% Write the FVCOM river forcing input file
%
% input  :
%   fout --- the NetCDF output
%   name --- river names in string
%   (Variables below can be writen in to a random order (except Time).)
%   Variable name | Description       | size               | unit 
%   Time            time                (nt)                 datenum format
%   Flux            discharge           (n, nt)              m3/s
%   Temperature     river temperature   (n, nt)              degree C
%   Salinity        river salinity      (n, nt)              psu
% 
% output :
%
% Siqi Li, SMAST
% 2022-09-21
%
% Updates:
%
%==========================================================================
function write_river(fout, name, varargin)

Ideal = read_varargin2(varargin, {'Ideal'});

varargin = read_varargin(varargin, {'Time'}, {[]});
varargin = read_varargin(varargin, {'Flux'}, {[]});
varargin = read_varargin(varargin, {'Temperature'}, {[]});
varargin = read_varargin(varargin, {'Salinity'}, {[]});



if isempty(Time)
    error('There should be at least one time.')
else
    nt = length(Time);
    [time, Itime, Itime2, Times] = convert_fvcom_time(Time, Ideal);
%     Times = datestr(Time, 'yyyy-mm-ddTHH:MM:SS.000000');
%     time = Time - datenum(1858, 11, 17);
%     Itime = floor(time);
%     Itime2 = (time - Itime) * 1000;
end


n = length(name);

if isempty(Flux)
    error('There has to be river flux.')
end
if isempty(Temperature)
   Temperature = ones(n, nt) * 20;
end
if isempty(Salinity)
   Salinity = ones(n, nt) * 5;
end

if size(Flux,1)~=n || size(Flux,2)~=nt
    error('Wrong size of Flux.')
end
if size(Temperature,1)~=n || size(Temperature,2)~=nt
    error('Wrong size of Temperature.')
end
if size(Salinity,1)~=n || size(Salinity,2)~=nt
    error('Wrong size of Salinity.')
end



% Create the nesting file
ncid = netcdf.create(fout, 'CLOBBER');

% Define global attributes
netcdf.putAtt(ncid, -1, 'source', 'FVCOM river input');

% Define dimensions
time_dimid = netcdf.defDim(ncid, 'time', 0);
namelen_dimid = netcdf.defDim(ncid, 'namelen', 80);
rivers_dimid = netcdf.defDim(ncid, 'rivers', n);
DateStrLen_dimid = netcdf.defDim(ncid, 'DateStrLen', 26);

% Define variables
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
% river_names
name_varid = netcdf.defVar(ncid, 'river_names', 'char', [namelen_dimid rivers_dimid]);
netcdf.putAtt(ncid, name_varid, 'long_name', 'river names');
% temperature
flux_varid = netcdf.defVar(ncid, 'river_flux', 'float', [rivers_dimid time_dimid]);
netcdf.putAtt(ncid, flux_varid, 'long_name', 'river runoff volume flux');
netcdf.putAtt(ncid, flux_varid, 'units', 'm^3s^-1');
% temperature
temp_varid = netcdf.defVar(ncid, 'river_temp', 'float', [rivers_dimid time_dimid]);
netcdf.putAtt(ncid, temp_varid, 'long_name', 'river runoff temperature');
netcdf.putAtt(ncid, temp_varid, 'units', 'Celsius');
% salinity
salinity_varid = netcdf.defVar(ncid, 'river_salt', 'float', [rivers_dimid time_dimid]);
netcdf.putAtt(ncid, salinity_varid, 'long_name', 'river runoff salinity');
netcdf.putAtt(ncid, salinity_varid, 'units', 'PSU');


% End define mode
netcdf.endDef(ncid);

% Write data
for i = 1 : n
    chr = blanks(80);
    chr(1:length(name{i})) = name{i};
    netcdf.putVar(ncid, name_varid, [0 i-1], [80 1], chr);
end
for it = 1 : nt
    disp(['---Writing data for time: ' Times(it, :)])
    netcdf.putVar(ncid, time_varid, it-1, 1, time(it));
    netcdf.putVar(ncid, Itime_varid, it-1, 1, Itime(it));
    netcdf.putVar(ncid, Itime2_varid, it-1, 1, Itime2(it));
    if isempty(Ideal)
        netcdf.putVar(ncid, Times_varid, [0 it-1], [length(Times(it,:)) 1], Times(it,:));
    end
    netcdf.putVar(ncid, flux_varid, [0 it-1], [n 1], Flux(:, it));
    netcdf.putVar(ncid, temp_varid, [0 it-1], [n 1], Temperature(:, it));
    netcdf.putVar(ncid, salinity_varid, [0 it-1], [n 1], Salinity(:, it));
end

% Close the nesting file
netcdf.close(ncid);


