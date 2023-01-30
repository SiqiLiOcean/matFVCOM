%==========================================================================
% Write hydro forcing 
% The output file is named as yyyymmddHH.LDASIN_DOMAIN#, where # is geoid.
%
% input  :
%   outdir --- output directory
%   geoid  --- geogrid file id
%   time   --- time in datenum
% 
% output :
%
% Siqi Li, SMAST
% 2023-01-27
%
% Updates:
%
%==========================================================================
function write_hydro_forcing(outdir, geoid, time, varargin)

fout = [outdir '/' datestr(time, 'yyyymmddHH') '.LDASIN_DOMAIN' num2str(geoid)];

i = 0;
ivar = 0;
while i < length(varargin)
    i = i + 1;
    ivar = ivar + 1;
    varname{ivar} = varargin{i};
    i = i + 1;
    var{ivar} = varargin{i};
end

varlist = {'LWDOWN', 'SWDOWN', 'PSFC', 'RAINRATE', ...
           'T2D', 'Q2D', 'U2D', 'V2D'};

if any(~ismember(varname, varlist)) || isempty(varargin)
    disp('Variable name is not in the list. Select one from the followings:')
    disp(varlist)
    error('')
end

if length(varname) < 7
    disp('Input variables insufficient (<7).')
    disp(varlist)
    error('')
elseif legnth(varname) == 7 && ismember('RAINRATE', varname)
    disp('Input variables insufficient (==7).')
    disp(varlist)
    error('')
end

Times = datestr(time, 'YYYY-mm-ddTHH:MM:SS ');


% Create new file.
ncid = netcdf.create(fout, 'CLOBBER');


% Define dimensions and variables
[nx, ny] = size(var{1}, [1 2]);
nx_dimid = netcdf.defDim(ncid, 'west_east', nx);
ny_dimid = netcdf.defDim(ncid, 'south_north', ny);
time_dimid = netcdf.defDim(ncid, 'Time', 0);
DateStrLen_dimid = netcdf.defDim(ncid, 'DateStrLen', 20);

% Variables
% time
Times_varid = netcdf.defVar(ncid,'Times', 'char', [DateStrLen_dimid time_dimid]);
netcdf.putAtt(ncid, Times_varid, 'format', 'YYYY-mm-ddTHH:MM:SS ');
% LWDOWN
if ismember('LWDOWN', varname)
    LWDOWN_varid = netcdf.defVar(ncid, 'LWDOWN', 'float', [nx_dimid ny_dimid time_dimid]);
    netcdf.putAtt(ncid, LWDOWN_varid, 'long_name', 'Downward longwave radiation');
    netcdf.putAtt(ncid, LWDOWN_varid, 'units', 'W/m2');
end
% SWDOWN
if ismember('SWDOWN', varname)
    SWDOWN_varid = netcdf.defVar(ncid, 'SWDOWN', 'float', [nx_dimid ny_dimid time_dimid]);
    netcdf.putAtt(ncid, SWDOWN_varid, 'long_name', 'Downward shortwave radiation');
    netcdf.putAtt(ncid, SWDOWN_varid, 'units', 'W/m2');
end
% PSFC
if ismember('PSFC', varname)
    PSFC_varid = netcdf.defVar(ncid, 'PSFC', 'float', [nx_dimid ny_dimid time_dimid]);
    netcdf.putAtt(ncid, PSFC_varid, 'long_name', 'Surface pressure');
    netcdf.putAtt(ncid, PSFC_varid, 'units', 'Pa');
end
% RAINRATE
if ismember('RAINRATE', varname)
    RAINRATE_varid = netcdf.defVar(ncid, 'RAINRATE', 'float', [nx_dimid ny_dimid time_dimid]);
    netcdf.putAtt(ncid, RAINRATE_varid, 'long_name', 'Precipitation rate');
    netcdf.putAtt(ncid, RAINRATE_varid, 'units', 'mm/s');
end
% T2D
if ismember('T2D', varname)
    T2D_varid = netcdf.defVar(ncid, 'T2D', 'float', [nx_dimid ny_dimid time_dimid]);
    netcdf.putAtt(ncid, T2D_varid, 'long_name', 'Surface temperature');
    netcdf.putAtt(ncid, T2D_varid, 'units', 'K');
end
% Q2D
if ismember('Q2D', varname)
    Q2D_varid = netcdf.defVar(ncid, 'Q2D', 'float', [nx_dimid ny_dimid time_dimid]);
    netcdf.putAtt(ncid, Q2D_varid, 'long_name', 'Surface specific humidity');
    netcdf.putAtt(ncid, Q2D_varid, 'units', 'kg/kg');
end
% U2D
if ismember('U2D', varname)
    U2D_varid = netcdf.defVar(ncid, 'U2D', 'float', [nx_dimid ny_dimid time_dimid]);
    netcdf.putAtt(ncid, U2D_varid, 'long_name', 'Surface u-wind');
    netcdf.putAtt(ncid, U2D_varid, 'units', 'm/s');
end
% V2D
if ismember('U2D', varname)
    V2D_varid = netcdf.defVar(ncid, 'V2D', 'float', [nx_dimid ny_dimid time_dimid]);
    netcdf.putAtt(ncid, V2D_varid, 'long_name', 'Surface v-wind');
    netcdf.putAtt(ncid, V2D_varid, 'units', 'm/s');
end


% Global attribute
netcdf.putAtt(ncid, -1, 'source', 'CFSv2 climatological forcing');

% End define mode
netcdf.endDef(ncid);

% Write data
it = 1;
netcdf.putVar(ncid, Times_varid, [0 it-1], [length(Times(it,:)) 1], Times(it,:));
for ivar = 1 : length(varname)
    cmd = ['netcdf.putVar(ncid, ' varname{ivar} '_varid, [0 0 it-1], [nx ny 1], var{ivar}(:,:,it));'];
    disp(['   ---Writing data for ' varname{ivar}])
    eval(cmd);
end


% Close the file
netcdf.close(ncid);


