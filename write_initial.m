%==========================================================================
% Write FVCOM initial NetCDF file
% 
% Input  : --- fini, initial ts file path and name
%          --- zsl, depths, (negative for ocean in the output)
%          --- time0, time in MATLAB datenum format
%          --- other variables
%
% Output : \
% 
% Usage  : write_initial(fini, zsl, datenum(2012, 10, 18, 0, 0, 0]), 'tsl', T);
%
% v1.0
%
% Siqi Li
% 2023-02-09
%
% Updates:
%
%==========================================================================
function write_initial(fini, time0, zsl, varargin)

varargin = read_varargin2(varargin, {'Ideal'});


ksl = length(zsl);

if ksl~=length(zsl(:))
    error('Wrong size of input zsl.')
end




i = 0;
ivar = 0;
while i < length(varargin)
    i = i + 1;
    ivar = ivar + 1;
    varname{ivar} = varargin{i};
    i = i + 1;
    var{ivar} = varargin{i};
end

varlist = ["tsl", "ssl", ...
           "Nitrogen", "Phytoplankton", "Zooplankton", "Detritus", ...
           "NH4", "NO3", "DOM", "Bacteria", ...
            "SiO3", "Small_phyto", "Large_phyto", ...
            "Microzooplankton", "Mesozooplankton", ...
            "Detritus_N", "Detritus_Si", ...
            "PO4", "Detritus_P", ...
            "Small_detritus", "Large_detritus"];

unitlist = ["degree C", "PSU", ...
            "mmole N m-3", "mmole C m-3", "mmole C m-3", "mmole C m-3", ...
            "mmole N m-3", "mmole N m-3", "mmole C m-3", "mmole C m-3", ...
            "mmole Si m-3", "mmole C m-3", "mmole C m-3", ...
            "mmole C m-3", "mmole C m-3", ...
            "mmole N m-3", "mmole Si m-3", ...
            "mmole P m-3", "mmole P m-3", ...
            "mmole C m-3", "mmole C m-3"];
longnamelist = ["Temperature", "Salinity", ...
                "Nitrogen", "Phytoplankton", "Zooplankton", "Detritus", ...
                "NH4", "NO3", "DOM", "Bacteria", ...
                "SiO3", "Small_phyto", "Large_phyto", ...
                "Microzooplankton", "Mesozooplankton", ...
                "Detritus_N", "Detritus_Si", ...
                "PO4", "Detritus_P", ...
                "Small_detritus", "Large_detritus"];


if any(~ismember(varname, varlist)) || isempty(varargin)
    disp('Variable name is not in the list. Select one from the followings:')
    disp(varlist)
    error('')
end


kz = length(zsl);
node = size(var{1}, 1);
nvar = length(var);

for i = 1 : nvar
    dim1 = size(var{i}, 1);
    dim2 = size(var{i}, 2);
    if dim1 ~= node || dim2 ~= kz
        error(['Wrong size of input: ' varname{i}])
    end
end





% Generate the four time variables
[time, Itime, Itime2, Times] = convert_fvcom_time(time0, Ideal);


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

for i = 1 : nvar
    j = contains(varlist, varname{i});
    name = varname{j};
    long = longnamelist{j};
    unit = unitlist{j};
    eval([name '_varid = netcdf.defVar(ncid, ''' name ''',''float'',[node_dimid ksl_dimid time_dimid]);']);
    eval(['netcdf.putAtt(ncid, ' name '_varid, ''long_name'',''' long ''');']);
    eval(['netcdf.putAtt(ncid, ' name '_varid, ''units'', ''' unit ''');']);
end


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
for it=1:1
    netcdf.putVar(ncid, time_varid, it-1, 1, time(it));
    netcdf.putVar(ncid, Itime_varid, it-1, 1, Itime(it));
    netcdf.putVar(ncid, Itime2_varid, it-1, 1, Itime2(it));
    if isempty(Ideal)
        netcdf.putVar(ncid, Times_varid, [0 it-1], [26 1], Times(it,:));
    end
    for i = 1 : nvar
        j = contains(varlist, varname{i});
        name = varname{j};
        eval(['netcdf.putVar(ncid, ' name '_varid, [0 0 it-1], [node ksl 1], var{i});']);
    end
end

% close NC file
netcdf.close(ncid)
