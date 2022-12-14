%==========================================================================
% Add the open boundary to FVCOM restart file.
%
% input  :
%   fin
%   fout
%   node_nodes --- node id of the open boundary
%   node_type  --- method of setting surface elevation. 
%                    0 --- prescribed elevation (Julian/non-Julian)
%                    1 --- radiation condition
% 
% output :
%
% Siqi Li, SMAST
% 2022-11-07
%
% Updates:
%
%==========================================================================
function add_restart_obc(fin, fout, obc_nodes, obc_type)

obc_nodes = obc_nodes(:);
obc_type = obc_type(:);
nobc = length(obc_nodes);


copyfile(fin, fout);

% Open the file.
ncid = netcdf.open(fout, 'WRITE');
[ndims, nvars] = netcdf.inq(ncid);
% Check the dimension nlsf
nobc_dimid = -1;
for i = 1 : ndims
    dimname = netcdf.inqDim(ncid, i-1);
    if strcmp(dimname, 'nobc')
        nobc_dimid = i-1;
        break
    end
end
if nobc_dimid>=0
    disp('Dimension nobc already exists. Rename it.')
    netcdf.reDef(ncid);
    netcdf.renameDim(ncid, nobc_dimid, 'old_nobc');
    netcdf.endDef(ncid);
end
netcdf.reDef(ncid);
nobc_dimid = netcdf.defDim(ncid, 'nobc', nobc);
netcdf.endDef(ncid);

% Check the variables
obc_nodes_varid = -1;
obc_type_varid = -1;
for i = 1 : nvars
    varname = netcdf.inqVar(ncid, i-1);
    if strcmp(varname, 'obc_nodes')
        obc_nodes_varid = i-1;
    elseif strcmp(varname, 'obc_type')
        obc_type_varid = i-1;
    end
end
% obc_nodes
if obc_nodes_varid>=0
    disp('Variable obc_nodes already exists. Rename it.');
    netcdf.reDef(ncid);
    netcdf.renameVar(ncid, obc_nodes_varid, 'old_obc_nodes');
    netcdf.endDef(ncid);
end
netcdf.reDef(ncid);
obc_nodes_varid = netcdf.defVar(ncid, 'obc_nodes', 'NC_INT', nobc_dimid);
netcdf.putAtt(ncid, obc_nodes_varid, 'long_name', 'Open Boundary Node Number');
netcdf.putAtt(ncid, obc_nodes_varid, 'grid', 'obc_grid');
netcdf.endDef(ncid);

% obc_type
if obc_type_varid>=0 
    disp('Variable obc_type already exists. Rename it.')
    netcdf.reDef(ncid);
    netcdf.renameVar(ncid, obc_type_varid, 'old_obc_type');
    netcdf.endDef(ncid);
end
netcdf.reDef(ncid);
obc_type_varid = netcdf.defVar(ncid, 'obc_type', 'NC_FLOAT', nobc_dimid);
netcdf.putAtt(ncid, obc_type_varid, 'long_name', 'Open Boundary Type');
netcdf.putAtt(ncid, obc_type_varid, 'grid', 'obc_grid');
netcdf.endDef(ncid);

% Write the variables
netcdf.putVar(ncid, obc_nodes_varid, obc_nodes);
netcdf.putVar(ncid, obc_type_varid, obc_type);

% Close the file
netcdf.close(ncid);

