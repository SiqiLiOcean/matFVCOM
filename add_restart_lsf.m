%==========================================================================
% Add longshore forcing to FVCOM restart file.
%
% input  :
%   fin
%   fout
%   lsf_nodes     --- longshore flow node id
%   geo           --- thermal wind flow adjustment scaling
%   wdf           --- wind driven flow adjustment scaling
%   lsf_nodes_2nd --- longshore flow node id (2nd)
% output :
%
% Siqi Li, SMAST
% 2022-11-07
%
% Updates:
% Added the 2nd array of LSF nodes as an optional input
%==========================================================================
function add_restart_lsf(fin, fout, lsf_nodes, geo, wdf, lsf_nodes_2nd)

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
for i = 1 : ndims
    dimname = netcdf.inqDim(ncid, i-1);
    if strcmp(dimname, 'nlsf')
        nlsf_dimid = i-1;
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

% geo
if exist('lsf_nodes_2nd', 'var')
    if geo_varid>=0
        disp('Variable geo already exists. Rename it.')
        netcdf.reDef(ncid);
        netcdf.renameVar(ncid, lsf_nodes_2nd_varid, 'old_geo');
        netcdf.endDef(ncid);
    end
    netcdf.reDef(ncid);
    lsf_nodes_2nd_varid = netcdf.defVar(ncid, 'geo', 'NC_FLOAT', nlsf_dimid);
    netcdf.putAtt(ncid, lsf_nodes_2nd_varid, 'long_name', 'Longshore Flow Node Number (2nd)');
    netcdf.putAtt(ncid, lsf_nodes_2nd_varid, 'grid', 'lsf_grid');
    netcdf.endDef(ncid);
end

% Write the variables
netcdf.putVar(ncid, lsf_nodes_varid, lsf_nodes);
netcdf.putVar(ncid, wdf_varid, wdf);
netcdf.putVar(ncid, geo_varid, geo);
if exist('lsf_nodes_2nd', 'var')
    netcdf.putVar(ncid, lsf_nodes_2nd_varid, lsf_nodes_2nd);
end

% Close the file
netcdf.close(ncid);

