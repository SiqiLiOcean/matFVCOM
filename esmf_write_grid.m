%==========================================================================
% matFVCOM package
% write grid nc for ESMF regrid
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% 2023-02-23
%
% Updates:
%
%==========================================================================
function esmf_write_grid(fout, grid_type, varargin)


switch(upper(grid_type))

    case 'FVCOM'
        lon = varargin{1};
        lat = varargin{2};
        nv = varargin{3};
        write_ugrid_fvcom(fout, lon, lat, nv);
    case 'WRF'
        lon = varargin{1};
        lat = varargin{2};
        write_esmf_wrf(fout, lon, lat);
%         if length(varargin) > 2
%             mask = varargin{3};
%         else
%             mask = ones(size(lon)-1);
%         end
%         write_esmf_rectangular(fout, lon, lat, mask);

    otherwise


end

end

function write_ugrid_fvcom(fout, lon, lat, nv)

node=length(lon);    
nele=length(nv);

% Create output NetCDF
ncid = netcdf.create(fout, 'CLOBBER');
%     netcdf.putAtt(ncid,netcdf.getConstant('GLOBAL'),'title',title);

% Dimension
dimid_node = netcdf.defDim(ncid, 'node', node);
dimid_nele = netcdf.defDim(ncid, 'nele', nele);
dimid_three = netcdf.defDim(ncid, 'three', 3);

% Variable
% fvcom_mesh
varid_mesh = netcdf.defVar(ncid, 'fvcom_mesh', 'int', []);
netcdf.putAtt(ncid, varid_mesh, 'cf_role', 'mesh_topology');
netcdf.putAtt(ncid, varid_mesh, 'topology_dimension', 2.);
netcdf.putAtt(ncid, varid_mesh, 'node_coordinates', 'lon lat');
netcdf.putAtt(ncid, varid_mesh, 'face_node_connectivity', 'nv');
% nv
varid_nv = netcdf.defVar(ncid, 'nv', 'int', [dimid_three dimid_nele]);
netcdf.putAtt(ncid, varid_nv, 'standard_name', 'face_node_connectivity');
netcdf.putAtt(ncid, varid_nv, 'start_index', 1.);
% lon
varid_lon = netcdf.defVar(ncid, 'lon', 'float', dimid_node);
netcdf.putAtt(ncid, varid_lon, 'standard_name', 'longitude');
netcdf.putAtt(ncid, varid_lon, 'units', 'degrees_east');
% lat
varid_lat = netcdf.defVar(ncid, 'lat', 'float', dimid_node);
netcdf.putAtt(ncid, varid_lat, 'standard_name', 'latitude');
netcdf.putAtt(ncid, varid_lat, 'units', 'degrees_north');

% End define mode
netcdf.endDef(ncid);

% Write data
netcdf.putVar(ncid, varid_nv, nv');
netcdf.putVar(ncid, varid_lat, lat);
netcdf.putVar(ncid, varid_lon, lon);

% Close output NetCDF
netcdf.close(ncid);

end

function write_esmf_wrf(fout, lon, lat)
% function write_esmf_rectangular(fout, lon, lat, mask)

[nlat, nlon] = size(lon);
node = nlon*nlat;
nele = (nlon-1) * (nlat-1);
lon_c = reshape(lon, node, 1);
lat_c = reshape(lat, node, 1);
% mask_c = reshape(mask, nele, 1);
nv = zeros(nele, 4);
for ele = 1 : nele
    %
    jele = mod(ele, nlat-1);
    if (jele==0)
        jele = nlat - 1;
    end
    iele = (ele-jele)/(nlat-1) + 1;
    %
    nv(ele,1) = (iele-1)  *nlat + jele;
    nv(ele,2) = (iele+1-1)*nlat + jele;
    nv(ele,3) = (iele+1-1)*nlat + jele + 1;
    nv(ele,4) = (iele-1)  *nlat + jele + 1;
end


% Create the output NetCDF
ncid = netcdf.create(fout, 'CLOBBER');
%     netcdf.putAtt(ncid,netcdf.getConstant('GLOBAL'),'title',title);

% Dimension
dimid_node = netcdf.defDim(ncid, 'nodeCount', node);
dimid_nele = netcdf.defDim(ncid, 'elementCount', nele);
dimid_four = netcdf.defDim(ncid, 'maxNodePElement', 4);
dimid_coordDim = netcdf.defDim(ncid, 'coordDim', 2);

% Variable
% nodeCoords
varid_nodeCoords = netcdf.defVar(ncid, 'nodeCoords', 'double', [dimid_coordDim dimid_node]);
netcdf.putAtt(ncid, varid_nodeCoords, 'units', 'degrees');
% elementConn
varid_elementConn = netcdf.defVar(ncid, 'elementConn', 'int', [dimid_four dimid_nele]);
netcdf.putAtt(ncid, varid_elementConn, 'long_name', 'Node indices that define the element connectivity');
netcdf.putAtt(ncid, varid_elementConn, 'FillValue', -1.);
%     netcdf.defVarFill(ncid,varid_elementConn,false,-1.);
% numElementConn
varid_numElementConn=netcdf.defVar(ncid,'numElementConn','byte',dimid_nele);
netcdf.putAtt(ncid,varid_numElementConn,'long_name','Number of nodes per element');
% % elementMask
% varid_elementMask=netcdf.defVar(ncid,'elementMask','int',dimid_nele);
% netcdf.putAtt(ncid,varid_elementMask,'FillValue',-9999.);

% End define mode
netcdf.endDef(ncid);

% Write data
netcdf.putVar(ncid, varid_nodeCoords, [lon_c lat_c]');
netcdf.putVar(ncid, varid_elementConn, nv');
netcdf.putVar(ncid, varid_numElementConn, ones(1,nele)*4);
% netcdf.putVar(ncid, varid_elementMask, mask_c);

% Close the file
netcdf.close(ncid);

end
