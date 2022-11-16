%==========================================================================
% Add longshore forcing to FVCOM restart file.
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% yyyy-mm-dd
%
% Updates:
%
%==========================================================================
function add_restart_lsf(fin, fout, lsf_nodes, geo, wdf)

lsf_nodes = lsf_nodes(:);
geo = geo(:);
wdf = wdf(:);
nlsf = length(lsf_nodes);


copyfile(fin, fout);

% Open the file.
ncid = netcdf.open(fout, 'WRITE');
[ndims, nvars] = netcdf.inq(ncid);
% Check the dimension nlsf
nlsf_dimid = -1;
nlsf_length = -1;
for i = 1 : ndims
    [dimname, dimlen] = netcdf.inqDim(ncid, i-1);
    if strcmp(dimname, 'nlsf')
        nlsf_dimid = i-1;
        nlsf_length = dimlen;
        break
    end
end
if nlsf_dimid>=0
    disp('Dimension nlsf already exists. Rename it.')
    netcdf.reDef(ncid);
    netcdf.renameDim(ncid, nlsf_dimid, 'old_nlsf');
    netcdf.endDef(ncid);
end
netcdf.reDef(ncid);
nlsf_dimid = netcdf.defDim(ncid, 'nlsf', nlsf);
netcdf.endDef(ncid);

% Check the variables
lsf_nodes_varid = -1;
wdf_varid = -1;
geo_varid = -1;
for i = 1 : nvars
    varname = netcdf.inqVar(ncid, i-1);
    if strcmp(varname, 'lsf_nodes')
        lsf_nodes_varid = i-1;
    elseif strcmp(varname, 'wdf')
        wdf_varid = i-1;
    elseif strcmp(varname, 'geo')
        geo_varid = i-1;
    end
end
% lsf_nodes
if lsf_nodes_varid>=0
    disp('Variable lsf_nodes already exists. Rename it.');
    netcdf.reDef(ncid);
    netcdf.renameVar(ncid, lsf_nodes_varid, 'old_lsf_nodes');
    netcdf.endDef(ncid);
end
netcdf.reDef(ncid);
lsf_nodes_varid = netcdf.defVar(ncid, 'lsf_nodes', 'NC_INT', nlsf_dimid);
netcdf.putAtt(ncid, lsf_nodes_varid, 'long_name', 'Longshore Flow Node Number');
netcdf.putAtt(ncid, lsf_nodes_varid, 'grid', 'lsf_grid');
netcdf.endDef(ncid);

% wdf
if wdf_varid>=0 
    disp('Variable wdf already exists. Rename it.')
    netcdf.reDef(ncid);
    netcdf.renameVar(ncid, wdf_varid, 'old_wdf');
    netcdf.endDef(ncid);
end
netcdf.reDef(ncid);
wdf_varid = netcdf.defVar(ncid, 'wdf', 'NC_FLOAT', nlsf_dimid);
netcdf.putAtt(ncid, wdf_varid, 'long_name', 'Wind Driven Flow Adjustment Scaling');
netcdf.putAtt(ncid, wdf_varid, 'valid_range', [0 1]);
netcdf.putAtt(ncid, wdf_varid, 'grid', 'lsf_grid');
netcdf.endDef(ncid);

% geo
if geo_varid>=0 
    disp('Variable geo already exists. Rename it.')
    netcdf.reDef(ncid);
    netcdf.renameVar(ncid, geo_varid, 'old_geo');
    netcdf.endDef(ncid);
end
netcdf.reDef(ncid);
geo_varid = netcdf.defVar(ncid, 'geo', 'NC_FLOAT', nlsf_dimid);
netcdf.putAtt(ncid, geo_varid, 'long_name', 'Thermal Wind Flow Adjustment Scaling');
netcdf.putAtt(ncid, geo_varid, 'valid_range', [0 1]);
netcdf.putAtt(ncid, geo_varid, 'grid', 'lsf_grid');
netcdf.endDef(ncid);


% Write the variables
netcdf.putVar(ncid, lsf_nodes_varid, lsf_nodes);
netcdf.putVar(ncid, wdf_varid, wdf);
netcdf.putVar(ncid, geo_varid, geo);

% Close the file
netcdf.close(ncid);

