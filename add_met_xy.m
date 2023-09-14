%==========================================================================
% Add the xy coordinate variables in the meteorological forcing file
% 
% Input  : --- fin, original meteorological forcing
%          --- xx, x-coordinate matrix
%          --- yy, y-coordinate matrix
%          --- fout, the new meteorological forcing file (optional)
%
% Output : \
% 
% Usage  : add_nesting_center(fin, fout);
%
% v1.0
%
% Siqi Li
% 2023-09-14
%
% Updates:
%==========================================================================
function add_met_xy(fin, xx, yy, fout)

if exist('fout', 'var')
    copyfile(fin, fout);
else
    fout = fin;
end


ncid = netcdf.open(fout, 'NC_WRITE');
netcdf.reDef(ncid);

xx_dimid = netcdf.inqDimID(ncid, 'west_east');
yy_dimid = netcdf.inqDimID(ncid, 'south_north');


xx_varid = netcdf.defVar(ncid, 'xx', 'float', [xx_dimid yy_dimid]);
netcdf.putAtt(ncid, xx_varid, 'description', 'Cartesian Coordinate X');
netcdf.putAtt(ncid, xx_varid, 'units', 'm');
netcdf.putAtt(ncid, xx_varid, 'coordinates', 'XLONG XLAT');

yy_varid = netcdf.defVar(ncid, 'yy', 'float', [xx_dimid yy_dimid]);
netcdf.putAtt(ncid, yy_varid, 'description', 'Cartesian Coordinate X');
netcdf.putAtt(ncid, yy_varid, 'units', 'm');
netcdf.putAtt(ncid, yy_varid, 'coordinates', 'XLONG XLAT');

netcdf.endDef(ncid);

netcdf.putVar(ncid, xx_varid, xx);
netcdf.putVar(ncid, yy_varid, yy);

netcdf.close(ncid);

