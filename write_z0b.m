%==========================================================================
% Write Z0b NetCDF file
% 
% Input  : --- fz0b, z0b file path and name
%          --- z0b, Bottom Roughness Lengthscale
%
% Output : \
% 
% Usage  : write_z0b(fz0b, z0b);
%
% v1.0
%
% Siqi Li
% 2021-04-22
%
% Updates:
%
%==========================================================================
function write_z0b(fz0b, z0b)


nele = length(z0b);

% create the output file.
ncid=netcdf.create(fz0b, 'CLOBBER');

%define the dimension
nele_dimid=netcdf.defDim(ncid, 'nele', nele);

%define variables
% zsl
z0b_varid = netcdf.defVar(ncid,'z0b', 'float', nele_dimid);
netcdf.putAtt(ncid,z0b_varid,'long_name', 'Bottom Roughness Lengthscale');
netcdf.putAtt(ncid,z0b_varid,'unit', 'meter');

%end define mode
netcdf.endDef(ncid);

%put data in the output file
netcdf.putVar(ncid, z0b_varid,z0b);

% close NC file
netcdf.close(ncid)