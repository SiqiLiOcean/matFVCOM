%==========================================================================
% Add el_press in the restart file.
% 
% Input  : --- fin, original input nesting file
%          --- fout, the new nesting file with center variables included
%
% Output : \
% 
% Usage  : add_restart_el_press(fin, fout);
%
% v1.0
%
% Siqi Li
% 2021-04-21
%
% Updates:
%
%==========================================================================
function add_restart_el_press(fin, fout)


copyfile(fin, fout);


% Open the output NC file
ncid = netcdf.open(fout, 'NC_WRITE');

% Re-define mode
netcdf.reDef(ncid);

% Get the dimension id and length.
dimid_node = netcdf.inqDimID(ncid, 'node');
[~, node] = netcdf.inqDim(ncid, dimid_node);
dimid_time = netcdf.inqDimID(ncid, 'time');
[~, nt] = netcdf.inqDim(ncid, dimid_time);

el_press = zeros(node, nt);


% Define the el_press variable.
varid_el_press = netcdf.defVar(ncid, 'el_press', 'float', [dimid_node dimid_time]);
netcdf.putAtt(ncid, varid_el_press, 'long_name', 'AIR-Pressure Induced Water Surface Elevation');
netcdf.putAtt(ncid, varid_el_press, 'units', 'meters');

% End define mode
netcdf.endDef(ncid);

% Write data into the output NC file.
for it = 1 : nt
    netcdf.putVar(ncid, varid_el_press,[0 it-1],[node 1],el_press(:, it));
end
% Close the output NC file.
netcdf.close(ncid);
