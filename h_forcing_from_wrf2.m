%==========================================================================
% Create WRF-Hydro forcing input from WRF hourly wrfout
%
% input  :
%   fin    --- input wrfout file
%   outdir --- output directory
%   Ramp   --- ramp time in hour; optional, default is 0.
%   nt     --- time length in hour; optional, default is Inf.
% 
% output :
%
% Siqi Li, SMAST
% 2022-05-16
%
% Updates:
%
%==========================================================================
function [RAINC0_out, RAINNC0_out] = h_forcing_from_wrf2(fin, outdir, varargin)


% Check if the input file exist (starting in R2017b)
if ~isfile(fin)
  disp('The input file does not exist')
  exit
end

varargin = read_varargin(varargin, {'Ramp'}, {0});
varargin = read_varargin(varargin, {'nt'}, {Inf});





% Find the domain id
k = strfind(fin, 'wrfout_d');
domain_id = str2num(fin(k+8:k+9));%str2num(fin(83:84));


% Read the variables
Times = ncread(fin, 'Times', [1 Ramp+1], [inf nt])';        % 2020-08-05_18:00:00
XLONG = ncread(fin, 'XLONG', [1 1 1], [Inf Inf 1]);         % east degree 
XLAT = ncread(fin, 'XLAT', [1 1 1], [Inf Inf 1]);           % norht degree
GLW = ncread(fin, 'GLW', [1 1 Ramp+1], [Inf Inf nt]);       % W m-2
SWDOWN = ncread(fin, 'SWDOWN', [1 1 Ramp+1], [Inf Inf nt]); % W m-2
Q2 = ncread(fin, 'Q2', [1 1 Ramp+1], [Inf Inf nt]);         % kg kg-1
T2 = ncread(fin, 'T2', [1 1 Ramp+1], [Inf Inf nt]);         % K
PSFC = ncread(fin, 'PSFC', [1 1 Ramp+1], [Inf Inf nt]);     % Pa
U10 = ncread(fin, 'U10', [1 1 Ramp+1], [Inf Inf nt]);       % m s-1
V10 = ncread(fin, 'V10', [1 1 Ramp+1], [Inf Inf nt]);       % m s-1
LAI = ncread(fin, 'LAI', [1 1 Ramp+1], [Inf Inf nt]);       % m2/m2 (Leaf area index)
VEGFRA = ncread(fin, 'VEGFRA', [1 1 Ramp+1], [Inf Inf nt]); % 1 (Vegetation fraction)

% Dimensions
[nx, ny] = size(XLONG);
nt = size(GLW,3);
dateStrLen = size(Times, 2);

%
RAINC_read = ncread(fin, 'RAINC', [1 1 Ramp+1], [Inf Inf nt]);   % mm
RAINNC_read = ncread(fin, 'RAINNC', [1 1 Ramp+1], [Inf Inf nt]); % mm
if Ramp>0
    RAINC_base = ncread(fin, 'RAINC', [1 1 Ramp], [Inf Inf 1]);   % mm
    RAINNC_base = ncread(fin, 'RAINNC', [1 1 Ramp], [Inf Inf 1]); % mm
else
    RAINC_base = zerso(nx, ny);
    RAINNC_base = zerso(nx, ny);
end

varargin = read_varargin(varargin, {'RAINC0'}, {RAINC_base});
varargin = read_varargin(varargin, {'RAINNC0'}, {RAINNC_base});

RAINC = RAINC_read - repmat(RAINC_base, 1, 1, nt) + repmat(RAINC0, 1, 1, nt);
RAINNC = RAINNC_read - repmat(RAINNC_base, 1, 1, nt) + repmat(RAINNC0, 1, 1, nt);

RAINC0_out = RAINC(:,:,end);
RAINNC0_out = RAINNC(:,:,end);

% -----------------------Write data into output----------------------------
for it = 1 : nt
    
disp(Times(it,:))

% DateStr1 = Times(it,[1 2 3 4 6 7 9 10 12 13]);   %'yyyymmddHH'
% DateStr2 = Times(it,[1 2 3 4 6 7 9 10 12 13 15 16]);   %'yyyymmddHHMM'


% fout1 = [outdir '/' DateStr1 '.LDASIN_DOMAIN' num2str(domain_id)];
fout1 = [outdir '/wrfout_d' num2str(domain_id, '%2.2d') '_' Times(it,:)];

% fout2 = [outdir '/' DateStr2 '.PRECIP_FORCING.nc'];

%--------------------------------------------------------------------------
    
% Create the NetCDF output1
ncid1 = netcdf.create(fout1,'CLOBBER');

% Define the dimensions
lon_dimid = netcdf.defDim(ncid1, 'west_east', nx);
lat_dimid = netcdf.defDim(ncid1, 'south_north', ny);
time_dimid = netcdf.defDim(ncid1, 'Time', netcdf.getConstant('NC_UNLIMITED'));
dateStrLen_dimid = netcdf.defDim(ncid1, 'DateStrLen', dateStrLen);

% Define variables
% Times
Times_varid = netcdf.defVar(ncid1, 'Time', 'char', [dateStrLen_dimid time_dimid]);
% XLONG
XLONG_varid = netcdf.defVar(ncid1, 'lon', 'float', [lon_dimid lat_dimid]);
netcdf.putAtt(ncid1, XLONG_varid, 'description', 'Longitude on mass grid');
netcdf.putAtt(ncid1, XLONG_varid, 'units', 'degrees longitude');
% XLAT
XLAT_varid = netcdf.defVar(ncid1, 'lat', 'float', [lon_dimid lat_dimid]);
netcdf.putAtt(ncid1, XLAT_varid, 'description', 'Latitude on mass grid');
netcdf.putAtt(ncid1, XLAT_varid, 'units', 'degree latitude');
% SWDOWN
SWDOWN_varid = netcdf.defVar(ncid1, 'SWDOWN', 'float', [lon_dimid lat_dimid time_dimid]);
netcdf.putAtt(ncid1, SWDOWN_varid, 'description', 'DOWNWARD SHORT WAVE FLUX AT GROUND SURFACE');
netcdf.putAtt(ncid1, SWDOWN_varid, 'units', 'W m-2');
% LWDOWN
GLW_varid = netcdf.defVar(ncid1, 'GLW', 'float', [lon_dimid lat_dimid time_dimid]);
netcdf.putAtt(ncid1, GLW_varid, 'description', 'DOWNWARD LONG WAVE FLUX AT GROUND SURFACE');
netcdf.putAtt(ncid1, GLW_varid, 'units', 'W m-2');
% Q2D
Q2_varid = netcdf.defVar(ncid1, 'Q2', 'float', [lon_dimid lat_dimid time_dimid]);
netcdf.putAtt(ncid1, Q2_varid, 'description', 'Q2 at 2 M');
netcdf.putAtt(ncid1, Q2_varid, 'units', 'kg kg-1');
% T2D
T2_varid = netcdf.defVar(ncid1, 'T2', 'float', [lon_dimid lat_dimid time_dimid]);
netcdf.putAtt(ncid1, T2_varid, 'description', 'TEMP at 2 M');
netcdf.putAtt(ncid1, T2_varid, 'units', 'K');
% PSFC
PSFC_varid = netcdf.defVar(ncid1, 'PSFC', 'float', [lon_dimid lat_dimid time_dimid]);
netcdf.putAtt(ncid1, PSFC_varid, 'description', 'SFC PRESSURE');
netcdf.putAtt(ncid1, PSFC_varid, 'units', 'Pa');
% U2D
U10_varid = netcdf.defVar(ncid1, 'U10', 'float', [lon_dimid lat_dimid time_dimid]);
netcdf.putAtt(ncid1, U10_varid, 'description', 'U at 10 M');
netcdf.putAtt(ncid1, U10_varid, 'units', 'm s-1');
% V2D
V10_varid = netcdf.defVar(ncid1, 'V10', 'float', [lon_dimid lat_dimid time_dimid]);
netcdf.putAtt(ncid1, V10_varid, 'description', 'V at 10 M');
netcdf.putAtt(ncid1, V10_varid, 'units', 'm s-1');
% RAINRATE
RAINC_varid = netcdf.defVar(ncid1, 'RAINC', 'float', [lon_dimid lat_dimid time_dimid]);
netcdf.putAtt(ncid1, RAINC_varid, 'description', 'ACCUMULATED TOTAL CUMULUS PRECIPITATION');
netcdf.putAtt(ncid1, RAINC_varid, 'units', 'mm');
% RAINRATE
RAINNC_varid = netcdf.defVar(ncid1, 'RAINNC', 'float', [lon_dimid lat_dimid time_dimid]);
netcdf.putAtt(ncid1, RAINNC_varid, 'description', 'ACCUMULATED TOTAL GRID SCALE PRECIPITATION');
netcdf.putAtt(ncid1, RAINNC_varid, 'units', 'mm');
% LAI
LAI_varid = netcdf.defVar(ncid1, 'LAI', 'float', [lon_dimid lat_dimid time_dimid]);
netcdf.putAtt(ncid1, LAI_varid, 'description', 'LEAF AREA INDEX');
netcdf.putAtt(ncid1, LAI_varid, 'units', 'm-2/m-2');
% VEGFRA
VEGFRA_varid = netcdf.defVar(ncid1, 'VEGFRA', 'float', [lon_dimid lat_dimid time_dimid]);
netcdf.putAtt(ncid1, VEGFRA_varid, 'description', 'LEAF AREA INDEX');
netcdf.putAtt(ncid1, VEGFRA_varid, 'units', '');

% Write global attribute
% netcdf.putAtt(ncid1, netcdf.getConstant('GLOBAL'), 'model', 'NECOFS-WRF');
% netcdf.putAtt(ncid1, netcdf.getConstant('GLOBAL'), 'website', 'http://134.88.228.119:8080/fvcomwms/');
netcdf.putAtt(ncid1, netcdf.getConstant('GLOBAL'), 'description', 'WRF-Hydro Input data (from WRF)');
netcdf.putAtt(ncid1, netcdf.getConstant('GLOBAL'), 'Author', 'Siqi Li, SMAST (sli4@umassd.edu)');




% End the define mode
netcdf.endDef(ncid1);

% Write data
netcdf.putVar(ncid1, XLONG_varid, XLONG);
netcdf.putVar(ncid1, XLAT_varid, XLAT);
netcdf.putVar(ncid1, Times_varid, [0 0], [dateStrLen 1], Times(it,:));
netcdf.putVar(ncid1, SWDOWN_varid, [0 0 0], [nx ny 1], SWDOWN(:,:,it));
netcdf.putVar(ncid1, GLW_varid, [0 0 0], [nx ny 1], GLW(:,:,it));
netcdf.putVar(ncid1, Q2_varid, [0 0 0], [nx ny 1], Q2(:,:,it));
netcdf.putVar(ncid1, T2_varid, [0 0 0], [nx ny 1], T2(:,:,it));
netcdf.putVar(ncid1, PSFC_varid, [0 0 0], [nx ny 1], PSFC(:,:,it));
netcdf.putVar(ncid1, U10_varid, [0 0 0], [nx ny 1], U10(:,:,it));
netcdf.putVar(ncid1, V10_varid, [0 0 0], [nx ny 1], V10(:,:,it));
netcdf.putVar(ncid1, RAINC_varid, [0 0 0], [nx ny 1], RAINC(:,:,it));
netcdf.putVar(ncid1, RAINNC_varid, [0 0 0], [nx ny 1], RAINNC(:,:,it));
netcdf.putVar(ncid1, LAI_varid, [0 0 0], [nx ny 1], LAI(:,:,it));
netcdf.putVar(ncid1, VEGFRA_varid, [0 0 0], [nx ny 1], VEGFRA(:,:,it));


netcdf.close(ncid1);


end
