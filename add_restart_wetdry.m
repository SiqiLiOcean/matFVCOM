%==========================================================================
% Add the following variables in the restart file, for WET-DRY case.
%   - wet_nodes
%   - wet_cells
%   - wet_nodes_pre_int
%   - wet_cells_pre_int
%   - wet_cells_pre_ext
% 
% Input  : --- fin, original input restart file
%          --- fout, the new restart file
%
% Output : \
% 
% Usage  : add_restart_wetdry(fin, fout);
%
% v1.0
%
% Siqi Li
% 2021-08-30
%
% Updates:
%==========================================================================
function add_restart_wetdry(fin, fout, varargin)


copyfile(fin, fout);


% Open the output NC file
ncid = netcdf.open(fout, 'NC_WRITE');

% Re-define mode
netcdf.reDef(ncid);

% Get the dimension id and length.
dimid_node = netcdf.inqDimID(ncid, 'node');
[~, node] = netcdf.inqDim(ncid, dimid_node);
dimid_nele = netcdf.inqDimID(ncid, 'nele');
[~, nele] = netcdf.inqDim(ncid, dimid_nele);
dimid_time = netcdf.inqDimID(ncid, 'time');
[~, nt] = netcdf.inqDim(ncid, dimid_time);


disp(['----Input Dimensions:'])
disp(['    node : ' num2str(node)])
disp(['    nele : ' num2str(nele)])
disp(['    time : ' num2str(nt)])
read_varargin(varargin, {'wet_nodes'}, {ones(node, nt)});
read_varargin(varargin, {'wet_cells'}, {ones(nele, nt)});
read_varargin(varargin, {'wet_nodes_pre_int'}, {ones(node, nt)});
read_varargin(varargin, {'wet_cells_pre_int'}, {ones(nele, nt)});
read_varargin(varargin, {'wet_cells_pre_ext'}, {ones(nele, nt)});


disp(['----Added variables:'])
disp(['    Name     Size           Range '])
disp(['    wet_ndoes         :' num2str(size(wet_ndoes)) '    ' num2str(range(wet_ndoes))])
disp(['    wet_cells         :' num2str(size(wet_cells)) '    ' num2str(range(wet_cells))])
disp(['    wet_nodes_pre_int :' num2str(size(wet_nodes_pre_int)) '    ' num2str(range(wet_nodes_pre_int))])
disp(['    wet_cells_pre_int :' num2str(size(wet_cells_pre_int)) '    ' num2str(range(wet_cells_pre_int))])
disp(['    wet_cells_pre_ext :' num2str(size(wet_cells_pre_ext)) '    ' num2str(range(wet_cells_pre_ext))])



% Define the el_press variable.
% wet_ndoes
varid_wet_ndoes = netcdf.defVar(ncid, 'wet_ndoes', 'float', [dimid_node dimid_time]);
netcdf.putAtt(ncid, varid_wet_ndoes, 'long_name', 'Wet_Nodes');
% wet_cells
varid_wet_cells = netcdf.defVar(ncid, 'wet_cells', 'float', [dimid_nele dimid_time]);
netcdf.putAtt(ncid, varid_wet_cells, 'long_name', 'Wet_Cells');
% wet_nodes_pre_int
varid_wet_nodes_pre_int = netcdf.defVar(ncid, 'wet_nodes_pre_int', 'float', [dimid_node dimid_time]);
netcdf.putAtt(ncid, varid_wet_nodes_pre_int, 'long_name', 'Wet_Nodes_At_Previous_Internal_Step');
% wet_cells_pre_int
varid_wet_cells_pre_int = netcdf.defVar(ncid, 'wet_cells_pre_int', 'float', [dimid_nele dimid_time]);
netcdf.putAtt(ncid, varid_wet_cells_pre_int, 'long_name', 'Wet_Cells_At_Previous_Internal_Step');
% wet_cells_pre_ext
varid_wet_cells_pre_ext = netcdf.defVar(ncid, 'wet_cells_pre_ext', 'float', [dimid_nele dimid_time]);
netcdf.putAtt(ncid, varid_wet_cells_pre_ext, 'long_name', 'Wet_Cells_At_Previous_External_Step');


% End define mode
netcdf.endDef(ncid);

% Write data into the output NC file.
for it = 1 : nt
    netcdf.putVar(ncid, varid_wet_ndoes, [0 it-1], [node 1], wet_ndoes(:, it));
    netcdf.putVar(ncid, varid_wet_cells, [0 it-1], [nele 1], wet_cells(:, it));
    netcdf.putVar(ncid, varid_wet_nodes_pre_int,  [0 it-1], [node 1], wet_nodes_pre_int(:, it));
    netcdf.putVar(ncid, varid_wet_cells_pre_int,  [0 it-1], [nele 1], wet_cells_pre_int(:, it));
    netcdf.putVar(ncid, varid_wet_cells_pre_ext,  [0 it-1], [nele 1], wet_cells_pre_ext(:, it));
end
% Close the output NC file.
netcdf.close(ncid);

