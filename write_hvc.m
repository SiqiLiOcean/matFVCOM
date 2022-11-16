%==========================================================================
% Write horizontal diffusion coefficient NetCDF file
% 
% Input  : --- fhvc, hvc file path and name
%          --- nn_hvc, horizontal diffusion coefficient on node
%          --- cc_hvc, horizontal diffusion coefficient on cell
%
% Output : \
% 
% Usage  : write_hvc(fhvc, nn_hvc, cc_hvc)
%
% v1.0
%
% Siqi Li
% 2021-11-17
%
% Updates:
%
%==========================================================================
function write_hvc(fhvc, nn_hvc, cc_hvc)


node = length(nn_hvc);
nele = length(cc_hvc);

% create the output file.
ncid=netcdf.create(fhvc, 'CLOBBER');

%define the dimension
node_dimid=netcdf.defDim(ncid, 'node', node);
nele_dimid=netcdf.defDim(ncid, 'nele', nele);

%define variables
% nn_hvc
nn_hvc_varid = netcdf.defVar(ncid,'nn_hvc', 'float', node_dimid);
netcdf.putAtt(ncid,nn_hvc_varid,'long_name', 'NN_HVC');
netcdf.putAtt(ncid,nn_hvc_varid,'unit', 'm2 s-1');
% cc_hvc
cc_hvc_varid = netcdf.defVar(ncid,'cc_hvc', 'float', nele_dimid);
netcdf.putAtt(ncid,cc_hvc_varid,'long_name', 'CC_HVC');
netcdf.putAtt(ncid,cc_hvc_varid,'unit', 'm2 s-1');

%end define mode
netcdf.endDef(ncid);

%put data in the output file
netcdf.putVar(ncid, nn_hvc_varid, nn_hvc);
netcdf.putVar(ncid, cc_hvc_varid, cc_hvc);

% close NC file
netcdf.close(ncid)

