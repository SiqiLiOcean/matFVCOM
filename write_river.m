 %==========================================================================
% Write the FVCOM river forcing input file
%
% input  :
%   fout --- the NetCDF output
%   name --- river names in string
%   (Variables below can be writen in to a random order (except Time).)
%   Variable name | Description                | size      | unit 
%   Time            time                         (nt)        datenum format
%   Flux            discharge                    (n, nt)     m3/s
%   Temperature     river temperature            (n, nt)     degree C
%   Salinity        river salinity               (n, nt)     psu
%   PO4             phosphate                    (n, nt)     mmol P/m3
%   NO3             nitrate                      (n, nt)     mmol N/m3
%   NH4             ammonium                     (n, nt)     mmol N/m3
%   SiO4            silicate                     (n, nt)     mmol Si/m3
%   DO              dissolved oxygen             (n, nt)     mmol O2/m3
%   TA              total alkalinity             (n, nt)     umol/kg 
%   DIC             dissolved inorganic carbon   (n, nt)     mmol C/m3
%   Bioalk          arbonate bioalkalinity       (n, nt)     umol/kg
%
%
% output :
%
% Siqi Li, SMAST
% 2022-09-21
%
% Updates:
% 2023-10-05  Siqi Li
%==========================================================================
function write_river(fout, name, time, varargin)

varargin = read_varargin2(varargin, {'Ideal'});

% % varargin = read_varargin(varargin, {'Flux'}, {0});
% % varargin = read_varargin(varargin, {'Temperature'}, {20});
% % varargin = read_varargin(varargin, {'Salinity'}, {5});
% % varargin = read_varargin(varargin, {'PO4'}, {1});
% % varargin = read_varargin(varargin, {'NO3'}, {18});
% % varargin = read_varargin(varargin, {'NH4'}, {3});
% % varargin = read_varargin(varargin, {'SiO4'}, {18});
% % varargin = read_varargin(varargin, {'DO'}, {330});
% % varargin = read_varargin(varargin, {'DIC'}, {1000});
% % varargin = read_varargin(varargin, {'TA'}, {800});
% % varargin = read_varargin(varargin, {'Bioalk'}, {250});


i = 0;
ivar = 0;
while i < length(varargin)
    i = i + 1;
    ivar = ivar + 1;
    varname{ivar} = varargin{i};
    i = i + 1;
    var{ivar} = varargin{i};
end

varlist = {'Flux', 'Temperature', 'Salinity', ...
           'PO4', 'NO3', 'NH4', 'SiO4', ...
           'DO', 'DIC', 'TA', 'Bioalk'};

if any(~ismember(varname, varlist)) || isempty(varargin)
    disp('Variable name is not in the list. Select one from the followings:')
    disp(varlist)
    error('')
end

nt = length(time);
[time, Itime, Itime2, Times] = convert_fvcom_time(time, Ideal);

n = length(name);

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
% river_names
name_varid = netcdf.defVar(ncid, 'river_names', 'char', [namelen_dimid rivers_dimid]);
netcdf.putAtt(ncid, name_varid, 'long_name', 'river names');

% temperature
if ismember('Flux', varname)
    Flux_varid = netcdf.defVar(ncid, 'river_flux', 'float', [rivers_dimid time_dimid]);
    netcdf.putAtt(ncid, Flux_varid, 'long_name', 'river runoff volume flux');
    netcdf.putAtt(ncid, Flux_varid, 'units', 'm^3s^-1');
end
% temperature
if ismember('Temperature', varname)
    Temperature_varid = netcdf.defVar(ncid, 'river_temp', 'float', [rivers_dimid time_dimid]);
    netcdf.putAtt(ncid, Temperature_varid, 'long_name', 'river runoff temperature');
    netcdf.putAtt(ncid, Temperature_varid, 'units', 'Celsius');
end
% salinity
if ismember('Salinity', varname)
    Salinity_varid = netcdf.defVar(ncid, 'river_salt', 'float', [rivers_dimid time_dimid]);
    netcdf.putAtt(ncid, Salinity_varid, 'long_name', 'river runoff salinity');
    netcdf.putAtt(ncid, Salinity_varid, 'units', 'PSU');
end

% PO4
if ismember('PO4', varname)
    PO4_varid = netcdf.defVar(ncid, 'N1_p', 'float', [rivers_dimid time_dimid]);
    netcdf.putAtt(ncid, PO4_varid, 'long_name', 'phosphate phosphorus');
    netcdf.putAtt(ncid, PO4_varid, 'units', 'mmol P/m^3');
end
% NO3
if ismember('NO3', varname)
    NO3_varid = netcdf.defVar(ncid, 'N3_n', 'float', [rivers_dimid time_dimid]);
    netcdf.putAtt(ncid, NO3_varid, 'long_name', 'nitrate nitrogen');
    netcdf.putAtt(ncid, NO3_varid, 'units', 'mmol N/m^3');
end
% NH4
if ismember('NH4', varname)
    NH4_varid = netcdf.defVar(ncid, 'N4_n', 'float', [rivers_dimid time_dimid]);
    netcdf.putAtt(ncid, NH4_varid, 'long_name', 'ammonium nitrogen');
    netcdf.putAtt(ncid, NH4_varid, 'units', 'mmol N/m^3');
end
% SiO4
if ismember('SiO4', varname)
    SiO4_varid = netcdf.defVar(ncid, 'N5_s', 'float', [rivers_dimid time_dimid]);
    netcdf.putAtt(ncid, SiO4_varid, 'long_name', 'silicate silicate');
    netcdf.putAtt(ncid, SiO4_varid, 'units', 'mmol Si/m^3');
end
% DO
if ismember('DO', varname)
    DO_varid = netcdf.defVar(ncid, 'O2_o', 'float', [rivers_dimid time_dimid]);
    netcdf.putAtt(ncid, DO_varid, 'long_name', 'dissolved oxygen');
    netcdf.putAtt(ncid, DO_varid, 'units', 'O_2/m^3');
end
% TA
if ismember('TA', varname)
    TA_varid = netcdf.defVar(ncid, 'O3_TA', 'float', [rivers_dimid time_dimid]);
    netcdf.putAtt(ncid, TA_varid, 'long_name', 'carbonate total alkalinity');
    netcdf.putAtt(ncid, TA_varid, 'units', 'umol/kg');
end
% DIC
if ismember('DIC', varname)
    DIC_varid = netcdf.defVar(ncid, 'O3_c', 'float', [rivers_dimid time_dimid]);
    netcdf.putAtt(ncid, DIC_varid, 'long_name', 'carbonate total dissolved inorganic carbon');
    netcdf.putAtt(ncid, DIC_varid, 'units', 'mmol C/m^3');
end
%
if ismember('Bioalk', varname)
    Bioalk_varid = netcdf.defVar(ncid, 'O3_bioalk', 'float', [rivers_dimid time_dimid]);
    netcdf.putAtt(ncid, Bioalk_varid, 'long_name', 'carbonate bioalkalinity');
    netcdf.putAtt(ncid, Bioalk_varid, 'units', 'umol/kg');
end

% End define mode
netcdf.endDef(ncid);

% Write data
for i = 1 : n
    chr = blanks(80);
    chr(1:length(name{i})) = name{i};
    netcdf.putVar(ncid, name_varid, [0 i-1], [80 1], chr);
end
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
    for ivar = 1 : length(varname)
        cmd = ['netcdf.putVar(ncid, ' varname{ivar} '_varid, [0 it-1], [n 1], var{ivar}(:,it));'];
        if mod(it, 10) == 1
            disp(['   ' varname{ivar}])
        end
        eval(cmd);
    end
end

% Close the nesting file
netcdf.close(ncid);


