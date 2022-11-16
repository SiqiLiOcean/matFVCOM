%==========================================================================
% Add the variables of element center in the nesting files
%   including h_center, siglay_center, siglev_center
% 
% Input  : --- fin, original input nesting file
%          --- fout, the new nesting file with center variables (optional)
%
% Output : \
% 
% Usage  : add_nesting_center(fin, fout);
%
% v1.0
%
% Siqi Li
% 2021-04-21
%
% Updates:
% 2022-11-01  Siqi Li  Modifications can be done on the original files.
%==========================================================================
function add_nesting_center(fin, fout)

if exist('fout', 'var')
    copyfile(fin, fout);
else
    fout = fin;
end

f = f_load_grid(fout, 'xy');

ncid = netcdf.open(fout, 'NC_WRITE');
netcdf.reDef(ncid);

nele_dimid = netcdf.inqDimID(ncid, 'nele');
siglev_dimid = netcdf.inqDimID(ncid, 'siglev');
siglay_dimid = netcdf.inqDimID(ncid, 'siglay');

h_center_varid=netcdf.defVar(ncid, 'h_center', 'float', nele_dimid);
netcdf.putAtt(ncid,h_center_varid, 'long_name', 'Bathymetry');
netcdf.putAtt(ncid,h_center_varid, 'standard_name', 'ocean_sigma/general_coordinate');
netcdf.putAtt(ncid,h_center_varid, 'units', 'm');
netcdf.putAtt(ncid,h_center_varid, 'grid', 'grid1 grid3');
netcdf.putAtt(ncid,h_center_varid, 'coordinates', 'latc lonc');
netcdf.putAtt(ncid,h_center_varid, 'grid_location', 'center');

siglay_center_varid = netcdf.defVar(ncid, 'siglay_center', 'float', [nele_dimid,siglay_dimid]);
netcdf.putAtt(ncid, siglay_center_varid, 'long_name', 'Sigma Layers');
netcdf.putAtt(ncid, siglay_center_varid, 'standard_name', 'sea_floor_depth_below_geoid');
netcdf.putAtt(ncid, siglay_center_varid, 'positive', 'up');
netcdf.putAtt(ncid, siglay_center_varid, 'valid_min', '-1');
netcdf.putAtt(ncid, siglay_center_varid, 'valid_max', '0');
netcdf.putAtt(ncid, siglay_center_varid, 'formula_terms', 'sigma: siglay_center eta: zeta_center depth: h_center');

siglev_center_varid=netcdf.defVar(ncid, 'siglev_center', 'float', [nele_dimid,siglev_dimid]);
netcdf.putAtt(ncid,siglev_center_varid, 'long_name', 'Sigma Levels');
netcdf.putAtt(ncid,siglev_center_varid, 'standard_name', 'sea_floor_depth_below_geoid');
netcdf.putAtt(ncid,siglev_center_varid, 'positive', 'up');
netcdf.putAtt(ncid,siglev_center_varid, 'valid_min', '-1');
netcdf.putAtt(ncid,siglev_center_varid, 'valid_max', '0');
netcdf.putAtt(ncid,siglev_center_varid, 'formula_terms', 'sigma: siglay_center eta: zeta_center depth: h_center');

netcdf.endDef(ncid);

netcdf.putVar(ncid, h_center_varid, f.hc);
netcdf.putVar(ncid, siglay_center_varid, f.siglayc);
netcdf.putVar(ncid, siglev_center_varid, f.siglevc);

netcdf.close(ncid);
