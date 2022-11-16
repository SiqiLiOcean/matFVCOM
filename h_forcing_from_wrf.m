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
function h_forcing_from_wrf(fin, outdir, varargin)


% Check if the input file exist (starting in R2017b)
if ~isfile(fin)
  disp('The input file does not exist')
  exit
end

varargin = read_varargin(varargin, {'Ramp'}, {0});
varargin = read_varargin(varargin, {'nt'}, {Inf});


% Find the domain id
k = strfind(fin, 'wrfout_d');
domain_id = fin(k+9:k+9);%str2num(fin(83:84));


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
RAINC = ncread(fin, 'RAINC', [1 1 Ramp+1], [Inf Inf nt]);   % mm
RAINNC = ncread(fin, 'RAINNC', [1 1 Ramp+1], [Inf Inf nt]); % mm


% Dimensions
[nx, ny, nt] = size(GLW);
dateStrLen = size(Times, 2);


% Calculate the specific humidity
%RH2 = wrf_calc_rh2(T2, PSFC, Q2) /100;
% https://gmd.copernicus.org/articles/12/1029/2019/gmd-12-1029-2019.pdf
RH2 = Q2 ./ (Q2 + 1);       % 2020-12-28

% Calculate the rain rate
% The unit should be mm s-1
ACCUMULATED_RAIN = RAINC + RAINNC;
RAINRATE = zeros(nx, ny, nt);
RAINRATE(:, :, 2:nt) = diff(ACCUMULATED_RAIN, 1, 3) / 3600.;


% Rotate the wind.
for it = 1 :nt
    [U10_rotate(:,:,it), V10_rotate(:,:,it)] = wrf_wind_xy2ll(XLONG, XLAT, U10(:,:,it), V10(:,:,it), 'wrfout', fin);
end




% -----------------------Write data into output----------------------------
for it = 1 : nt
    
disp(Times(it,:))

DateStr1 = Times(it,[1 2 3 4 6 7 9 10 12 13]);   %'yyyymmddHH'
% DateStr2 = Times(it,[1 2 3 4 6 7 9 10 12 13 15 16]);   %'yyyymmddHHMM'


fout1 = [outdir '/' DateStr1 '.LDASIN_DOMAIN' num2str(domain_id)];
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
Times_varid = netcdf.defVar(ncid1, 'Times', 'char', [dateStrLen_dimid time_dimid]);
% XLONG
XLONG_varid = netcdf.defVar(ncid1, 'XLONG', 'float', [lon_dimid lat_dimid]);
netcdf.putAtt(ncid1, XLONG_varid, 'description', 'LONGITUDE, WEST IS NEGATIVE');
netcdf.putAtt(ncid1, XLONG_varid, 'units', 'degree_east');
% XLAT
XLAT_varid = netcdf.defVar(ncid1, 'XLAT', 'float', [lon_dimid lat_dimid]);
netcdf.putAtt(ncid1, XLAT_varid, 'description', 'LATITUDE, SOUTH IS NEGATIVE');
netcdf.putAtt(ncid1, XLAT_varid, 'units', 'degree_north');
% SWDOWN
SWDOWN_varid = netcdf.defVar(ncid1, 'SWDOWN', 'float', [lon_dimid lat_dimid time_dimid]);
netcdf.putAtt(ncid1, SWDOWN_varid, 'description', 'Incoming shortwave radiation');
netcdf.putAtt(ncid1, SWDOWN_varid, 'units', 'W m-2');
% LWDOWN
LWDOWN_varid = netcdf.defVar(ncid1, 'LWDOWN', 'float', [lon_dimid lat_dimid time_dimid]);
netcdf.putAtt(ncid1, LWDOWN_varid, 'description', 'Incoming longwave radiation');
netcdf.putAtt(ncid1, LWDOWN_varid, 'units', 'W m-2');
% Q2D
Q2D_varid = netcdf.defVar(ncid1, 'Q2D', 'float', [lon_dimid lat_dimid time_dimid]);
netcdf.putAtt(ncid1, Q2D_varid, 'description', 'Specific humidity');
netcdf.putAtt(ncid1, Q2D_varid, 'units', 'kg kg-1');
% T2D
T2D_varid = netcdf.defVar(ncid1, 'T2D', 'float', [lon_dimid lat_dimid time_dimid]);
netcdf.putAtt(ncid1, T2D_varid, 'description', 'Air temperature');
netcdf.putAtt(ncid1, T2D_varid, 'units', 'K');
% PSFC
PSFC_varid = netcdf.defVar(ncid1, 'PSFC', 'float', [lon_dimid lat_dimid time_dimid]);
netcdf.putAtt(ncid1, PSFC_varid, 'description', 'Surface pressure');
netcdf.putAtt(ncid1, PSFC_varid, 'units', 'Pa');
% U2D
U2D_varid = netcdf.defVar(ncid1, 'U2D', 'float', [lon_dimid lat_dimid time_dimid]);
netcdf.putAtt(ncid1, U2D_varid, 'description', 'Near surface wind in the u-component');
netcdf.putAtt(ncid1, U2D_varid, 'units', 'm s-1');
% V2D
V2D_varid = netcdf.defVar(ncid1, 'V2D', 'float', [lon_dimid lat_dimid time_dimid]);
netcdf.putAtt(ncid1, V2D_varid, 'description', 'Near surface wind in the v-component');
netcdf.putAtt(ncid1, V2D_varid, 'units', 'm s-1');
% RAINRATE
RAINRATE_varid = netcdf.defVar(ncid1, 'RAINRATE', 'float', [lon_dimid lat_dimid time_dimid]);
netcdf.putAtt(ncid1, RAINRATE_varid, 'description', 'Precipitation rate');
netcdf.putAtt(ncid1, RAINRATE_varid, 'units', 'mm s-1');


% Write global attribute
% netcdf.putAtt(ncid1, netcdf.getConstant('GLOBAL'), 'model', 'NECOFS-WRF');
% netcdf.putAtt(ncid1, netcdf.getConstant('GLOBAL'), 'website', 'http://134.88.228.119:8080/fvcomwms/');
netcdf.putAtt(ncid1, netcdf.getConstant('GLOBAL'), 'description', 'Input data for Nation Water Model from NECOFS-WRF');
netcdf.putAtt(ncid1, netcdf.getConstant('GLOBAL'), 'Author', 'Siqi Li, SMAST (sli4@umassd.edu)');




% End the define mode
netcdf.endDef(ncid1);

% Write data
netcdf.putVar(ncid1, XLONG_varid, XLONG);
netcdf.putVar(ncid1, XLAT_varid, XLAT);
netcdf.putVar(ncid1, Times_varid, [0 0], [dateStrLen 1], Times(it,:));
netcdf.putVar(ncid1, SWDOWN_varid, [0 0 0], [nx ny 1], SWDOWN(:,:,it));
netcdf.putVar(ncid1, LWDOWN_varid, [0 0 0], [nx ny 1], GLW(:,:,it));
netcdf.putVar(ncid1, Q2D_varid, [0 0 0], [nx ny 1], RH2(:,:,it));
netcdf.putVar(ncid1, T2D_varid, [0 0 0], [nx ny 1], T2(:,:,it));
netcdf.putVar(ncid1, PSFC_varid, [0 0 0], [nx ny 1], PSFC(:,:,it));
netcdf.putVar(ncid1, U2D_varid, [0 0 0], [nx ny 1], U10_rotate(:,:,it));
netcdf.putVar(ncid1, V2D_varid, [0 0 0], [nx ny 1], V10_rotate(:,:,it));
netcdf.putVar(ncid1, RAINRATE_varid, [0 0 0], [nx ny 1], RAINRATE(:,:,it));

netcdf.close(ncid1);


%--------------------------------------------------------------------------

% % Create the NetCDF output2
% ncid2 = netcdf.create(fout2,'CLOBBER');
% 
% % Define the dimensions
% lon_dimid = netcdf.defDim(ncid2, 'west_east', nx);
% lat_dimid = netcdf.defDim(ncid2, 'south_north', ny);
% time_dimid = netcdf.defDim(ncid2, 'Time', netcdf.getConstant('NC_UNLIMITED'));
% dateStrLen_dimid = netcdf.defDim(ncid2, 'DateStrLen', dateStrLen);
% 
% % Define variables
% % Times
% Times_varid = netcdf.defVar(ncid2, 'Times', 'char', [dateStrLen_dimid time_dimid]);
% % XLONG
% XLONG_varid = netcdf.defVar(ncid2, 'XLONG', 'float', [lon_dimid lat_dimid]);
% netcdf.putAtt(ncid2, XLONG_varid, 'description', 'LONGITUDE, WEST IS NEGATIVE');
% netcdf.putAtt(ncid2, XLONG_varid, 'units', 'degree_east');
% % XLAT
% XLAT_varid = netcdf.defVar(ncid2, 'XLAT', 'float', [lon_dimid lat_dimid]);
% netcdf.putAtt(ncid2, XLAT_varid, 'description', 'LATITUDE, SOUTH IS NEGATIVE');
% netcdf.putAtt(ncid2, XLAT_varid, 'units', 'degree_north');
% % RAINRATE
% RAINRATE_varid = netcdf.defVar(ncid2, 'RAINRATE', 'float', [lon_dimid lat_dimid time_dimid]);
% netcdf.putAtt(ncid2, RAINRATE_varid, 'description', 'Precipitation rate');
% netcdf.putAtt(ncid2, RAINRATE_varid, 'units', 'mm s-1');
% 
% 
% % Write global attribute
% % netcdf.putAtt(ncid1, netcdf.getConstant('GLOBAL'), 'model', 'NECOFS-WRF');
% % netcdf.putAtt(ncid1, netcdf.getConstant('GLOBAL'), 'website', 'http://134.88.228.119:8080/fvcomwms/');
% netcdf.putAtt(ncid2, netcdf.getConstant('GLOBAL'), 'description', 'Input data (Precipitation) for Nation Water Model from NECOFS-WRF');
% netcdf.putAtt(ncid2, netcdf.getConstant('GLOBAL'), 'Author', 'Siqi Li, SMAST (sli4@umassd.edu)');
% 
% 
% 
% 
% % End the define mode
% netcdf.endDef(ncid2);
% 
% % Write data
% netcdf.putVar(ncid2, RAINRATE_varid, [0 0 0], [nx ny 1], RAINRATE(:,:,it));
% 
% netcdf.close(ncid2);


end
