%==========================================================================
% Write FVCOM meteorological forcing input (FVCOM grid)
%
% input  :
%   fout --- output file path and name
%   lon  --- longitude
%   lat  --- latitude
%   nv   --- nv
%   time --- time
%   
% 
% output :
%
% Usage : write_met_forcing(fout, lon, lat, time, 'air_pressure', slp);
%
% Siqi Li, SMAST
% 2023-01-03
%
% Updates:
%
%==========================================================================
function write_met_forcing_fvcom(fout, x, y, nv, time, varargin)

varargin = read_varargin(varargin, {'Coordinate'}, {'xy'});

i = 0;
ivar = 0;
while i < length(varargin)
    i = i + 1;
    ivar = ivar + 1;
    varname{ivar} = varargin{i};
    i = i + 1;
    var{ivar} = varargin{i};
end

varlist = {'uwind_speed', 'vwind_speed', 'uwind_stress', 'vwind_stress', ...
           'short_wave', 'net_heat_flux', ...
           'air_pressure', ...
           'evaporation', 'precipitation', ...
           'T2', 'SPQ', 'cloud_cover'};

if any(~ismember(varname, varlist)) || isempty(varargin)
    disp('Variable name is not in the list. Select one from the followings:')
    disp(varlist)
    error('')
end

Times = datestr(time, 'YYYY-mm-ddTHH:MM:SS');
% time = time - datenum(1858, 11, 17);
[time, Itime, Itime2, Times] = convert_fvcom_time(time);


% Create new file.
ncid = netcdf.create(fout, 'CLOBBER');

% Define dimensions and variables
node = length(x);
nele = size(nv, 1);
nt = length(time);
DateStrLen = 26;
node_dimid = netcdf.defDim(ncid, 'node', node);
nele_dimid = netcdf.defDim(ncid, 'nele', nele);
three_dimid = netcdf.defDim(ncid, 'three', 3);
time_dimid = netcdf.defDim(ncid, 'time', 0);
DateStrLen_dimid = netcdf.defDim(ncid, 'DateStrLen', DateStrLen);

if strcmp(Coordinate, 'xy')
    % x
    x_varid = netcdf.defVar(ncid, 'x', 'float', node_dimid);
    netcdf.putAtt(ncid,x_varid, 'long_name', 'nodal x-coordinate');
    netcdf.putAtt(ncid,x_varid, 'units', 'meters');
    % y
    y_varid = netcdf.defVar(ncid,'y', 'float', node_dimid);
    netcdf.putAtt(ncid,y_varid, 'long_name', 'nodal y-coordinate');
    netcdf.putAtt(ncid,y_varid, 'units', 'meters');
else
    % lon
    x_varid = netcdf.defVar(ncid, 'lon', 'float', node_dimid);
    netcdf.putAtt(ncid,x_varid, 'long_name', 'nodal longitude');
    netcdf.putAtt(ncid,x_varid, 'units', 'degrees_east');
    % lat
    y_varid = netcdf.defVar(ncid,'lat', 'float', node_dimid);
    netcdf.putAtt(ncid,y_varid, 'long_name', 'nodal latitude');
    netcdf.putAtt(ncid,y_varid, 'units', 'degrees_north');
end
% nv
nv_varid = netcdf.defVar(ncid, 'nv', 'int', [nele_dimid three_dimid]);
netcdf.putAtt(ncid, nv_varid, 'long_name', 'nodes surrounding element');
% % xc
% xc_varid = netcdf.defVar(ncid, 'xc','float', nele_dimid);
% netcdf.putAtt(ncid, xc_varid, 'long_name', 'zonal x-coordinate');
% netcdf.putAtt(ncid, xc_varid, 'units', 'meters');
% % yc
% yc_varid = netcdf.defVar(ncid, 'yc', 'float', nele_dimid);
% netcdf.putAtt(ncid, yc_varid, 'long_name', 'zonal y-coordinate');
% netcdf.putAtt(ncid, yc_varid, 'units', 'meters');

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

% uwind_speed
if ismember('uwind_speed', varname)
    uwind_speed_varid = netcdf.defVar(ncid, 'uwind_speed', 'float', [nele_dimid time_dimid]);
    netcdf.putAtt(ncid, uwind_speed_varid, 'long_name', 'Eastward Wind Speed');
    netcdf.putAtt(ncid, uwind_speed_varid, 'units', 'm/s');
end
% vwind_speed
if ismember('vwind_speed', varname)
    vwind_speed_varid = netcdf.defVar(ncid, 'vwind_speed', 'float', [nele_dimid time_dimid]);
    netcdf.putAtt(ncid, vwind_speed_varid, 'long_name', 'Northtward Wind Speed');
    netcdf.putAtt(ncid, vwind_speed_varid, 'units', 'm/s');
end
% uwind_stress
if ismember('uwind_stress', varname)
    uwind_stress_varid = netcdf.defVar(ncid, 'uwind_stress', 'float', [nele_dimid time_dimid]);
    netcdf.putAtt(ncid, uwind_stress_varid, 'long_name', 'Eastward Wind Stress');
    netcdf.putAtt(ncid, uwind_stress_varid, 'units', 'Pa');
end
% vwind_stress
if ismember('vwind_stress', varname)
    vwind_stress_varid = netcdf.defVar(ncid, 'vwind_stress', 'float', [nele_dimid time_dimid]);
    netcdf.putAtt(ncid, vwind_stress_varid, 'long_name', 'Northward Wind Speed');
    netcdf.putAtt(ncid, vwind_stress_varid, 'units', 'Pa');
end
% short_wave
if ismember('short_wave', varname)
    short_wave_varid = netcdf.defVar(ncid, 'short_wave', 'float', [node_dimid time_dimid]);
    netcdf.putAtt(ncid, short_wave_varid, 'long_name', 'Short Wave Radiation');
    netcdf.putAtt(ncid, short_wave_varid, 'units', 'W m-2');
end
% net_heat_flux
if ismember('net_heat_flux', varname)
    net_heat_flux_varid = netcdf.defVar(ncid, 'net_heat_flux', 'float', [node_dimid time_dimid]);
    netcdf.putAtt(ncid, net_heat_flux_varid, 'long_name', 'Surface Net Heat Flux');
    netcdf.putAtt(ncid, net_heat_flux_varid, 'units', 'W m-2');
end
% air_pressure
if ismember('air_pressure', varname)
    air_pressure_varid = netcdf.defVar(ncid, 'air_pressure', 'float', [node_dimid time_dimid]);
    netcdf.putAtt(ncid, air_pressure_varid, 'long_name', 'Sea surface air pressure');
    netcdf.putAtt(ncid, air_pressure_varid, 'units', 'Pa');
end
% precipitation
if ismember('precipitation', varname)
    precipitation_varid = netcdf.defVar(ncid, 'precip', 'float', [node_dimid time_dimid]);
    netcdf.putAtt(ncid, precipitation_varid, 'long_name', 'Precipitation, ocean lose water is negative');
    netcdf.putAtt(ncid, precipitation_varid, 'units', 'm s-1');
end
% evaporation
if ismember('evaporation', varname)
    evaporation_varid = netcdf.defVar(ncid, 'evap', 'float', [node_dimid time_dimid]);
    netcdf.putAtt(ncid, evaporation_varid, 'long_name', 'Evaporation, ocean lose water is negative');
    netcdf.putAtt(ncid, evaporation_varid, 'units', 'm s-1');
end
if ismember('T2', varname)
    T2_varid = netcdf.defVar(ncid, 'T2', 'float', [node_dimid time_dimid]);
    netcdf.putAtt(ncid, T2_varid, 'long_name', 'Sea surface air temperature');
    netcdf.putAtt(ncid, T2_varid, 'units', 'degree (C)');
end
% SPQ
if ismember('SPQ', varname)
    Q2_varid = netcdf.defVar(ncid, 'SPQ', 'float', [node_dimid time_dimid]);
    netcdf.putAtt(ncid, Q2_varid, 'long_name', 'Specific humidity');
    netcdf.putAtt(ncid, Q2_varid, 'units', 'kg/kg');
end
% cloud_cover
if ismember('cloud_cover', varname)
    cloud_cover_varid = netcdf.defVar(ncid, 'cloud_cover', 'float', [node_dimid time_dimid]);
    netcdf.putAtt(ncid, cloud_cover_varid, 'long_name', 'Total cloud cover');
    netcdf.putAtt(ncid, cloud_cover_varid, 'units', '1');
end

% Global attribute
netcdf.putAtt(ncid, -1, 'source', 'fvcom grid (unstructured) surface forcing');


% End define mode
netcdf.endDef(ncid);

% Write data
disp('---Writing data for x')
netcdf.putVar(ncid, x_varid, x);
disp('---Writing data for y')
netcdf.putVar(ncid, y_varid, y);
disp('---Writing data for nv')
netcdf.putVar(ncid, nv_varid, nv);
for it=1:nt
    disp(['---Writing data for time: ' num2str(it, '%5.5d')])
    netcdf.putVar(ncid, time_varid, it-1, 1, time(it));
    netcdf.putVar(ncid, Itime_varid, it-1, 1, Itime(it));
    netcdf.putVar(ncid, Itime2_varid, it-1, 1, Itime2(it));    
    netcdf.putVar(ncid, Times_varid, [0 it-1], [length(Times(it,:)) 1], Times(it,:));
    for ivar = 1 : length(varname)
        if contains(varname{ivar}, 'wind')
            n = nele;
        else
            n = node;
        end
        cmd = ['netcdf.putVar(ncid, ' varname{ivar} '_varid, [0 it-1], [n 1], var{ivar}(:,it));'];
        disp(['   ---Writing data for ' varname{ivar}])
        eval(cmd);
    end
end

% Close the file
netcdf.close(ncid);



