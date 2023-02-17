%==========================================================================
% Write FVCOM TS initial NetCDF file
% 
% Input  : --- fini, initial ts file path and name
%          --- zsl, depths, (negative for ocean in the output)
%          --- tsl, temperature, degree C
%          --- ssl, salinity, psu
%          --- time0, time in MATLAB datenum format
%
% Output : \
% 
% Usage  : write_initial_ts(fini, zsl, tsl, ssl, datenum(2012, 10, 18, 0, 0, 0]));
%
% v1.0
%
% Siqi Li
% 2021-04-21
%
% Updates:
%
%==========================================================================
function write_initial_ts(fini, zsl, tsl, ssl, time0)

varargin = read_varargin2(varargin, {'Ideal'});

ksl = length(zsl);

if ksl~=length(zsl(:))
    error('Wrong size of input zsl.')
end

dims1 = size(tsl);
dims2 = size(ssl);
if length(dims1)~=2
    error('Input tsl and ssl should be in size of [node, ksl]')
end
if dims1(1)~=dims2(1) || dims1(2)~=dims2(2)
    error('Inputs tsl and ssl should be in the same size.')
end

node = dims1(1);
if dims1(2)~=ksl
    error('The 2nd dimension of input tsl should be ksl.')
end

% Generate the four time variables
[time, Itime, Itime2, Times] = convert_fvcom_time(time0, Ideal);
% mjd_ref=datenum(1858,11,17,0,0,0); 
% time = datenum(time0) - mjd_ref;
% Times = datestr(time0, 'yyyy-mm-ddTHH:MM:SS.000000');
% Itime = floor(time);
% Itime2 = (time-Itime) * 24 * 3600 * 1000;

% create the output file.
ncid=netcdf.create(fini, 'CLOBBER');

%define the dimension
node_dimid=netcdf.defDim(ncid, 'node', node);
time_dimid=netcdf.defDim(ncid,'time',netcdf.getConstant('NC_UNLIMITED'));
DateStrLen_dimid=netcdf.defDim(ncid,'DateStrLen',26);
ksl_dimid=netcdf.defDim(ncid, 'ksl', ksl);

%define variables

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

% zsl
zsl_varid = netcdf.defVar(ncid, 'zsl', 'float', ksl_dimid);
netcdf.putAtt(ncid,zsl_varid, 'long_name', 'Standard Depths');
netcdf.putAtt(ncid,zsl_varid, 'unit', 'meter');
% tsl
tsl_varid = netcdf.defVar(ncid, 'tsl','float',[node_dimid ksl_dimid time_dimid]);
netcdf.putAtt(ncid,tsl_varid, 'long_name','Temperature');
% ssl
ssl_varid = netcdf.defVar(ncid, 'ssl','float',[node_dimid ksl_dimid time_dimid]);
netcdf.putAtt(ncid,ssl_varid, 'long_name','Salinity');

%write global attributes
% netcdf.putAtt(ncid,netcdf.getConstant('GLOBAL'),'title','scs forcing)');
% netcdf.putAtt(ncid,netcdf.getConstant('GLOBAL'),'institution','school for Marine Science and Technology');
% netcdf.putAtt(ncid,netcdf.getConstant('GLOBAL'),'source','FVCOM grid (unstructured) surface forcing');
% netcdf.putAtt(ncid,netcdf.getConstant('GLOBAL'),'history','model started at 20/11/2016  15:10');
% netcdf.putAtt(ncid,netcdf.getConstant('GLOBAL'),'referecnes','http://fvcom.smast.umassd.edu, http://codfish.smast.umassd.edu');
% netcdf.putAtt(ncid,netcdf.getConstant('GLOBAL'),'Conventions','CF-1.0');
% netcdf.putAtt(ncid,netcdf.getConstant('GLOBAL'),'CoordinateSystem','Cartesian');
% netcdf.putAtt(ncid,netcdf.getConstant('GLOBAL'),'CoordinateProjection','none');

%end define mode
netcdf.endDef(ncid);

%put data in the output file
netcdf.putVar(ncid,zsl_varid, zsl);
for i=1:1
    netcdf.putVar(ncid, time_varid, i-1, 1, time(i));
    netcdf.putVar(ncid, Itime_varid, i-1, 1, Itime(i));
    netcdf.putVar(ncid, Itime2_varid, i-1, 1, Itime2(i));
    if isempty(Ideal)
        netcdf.putVar(ncid, Times_varid, [0 i-1], [26 1], Times(i,:));
    end
    netcdf.putVar(ncid, tsl_varid, [0 0 i-1], [node ksl 1], tsl);
    netcdf.putVar(ncid, ssl_varid, [0 0 i-1], [node ksl 1], ssl);
end

% close NC file
netcdf.close(ncid)
