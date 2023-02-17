%==========================================================================
% Add el_press in the restart file.
% 
% Input  : --- fin, original input nesting file
%          --- fout, the new nesting file with center variables included
%          --- dye, dye in (node, nsiglay, nt) (optional) 
% Output : \
% 
% Usage  : add_restart_dye(fin, fout, dye);
%
% v1.0
%
% Siqi Li
% 2023-02-16
%
% Updates:
%
%==========================================================================
function add_restart_dye(fin, fout, varargin)


copyfile(fin, fout);


% Open the output NC file
ncid = netcdf.open(fout, 'NC_WRITE');

% Re-define mode
netcdf.reDef(ncid);

% Get the dimension id and length.
dimid_node = netcdf.inqDimID(ncid, 'node');
[~, node] = netcdf.inqDim(ncid, dimid_node);
dimid_nsiglay = netcdf.inqDimID(ncid, 'siglay');
[~, nsiglay] = netcdf.inqDim(ncid, dimid_nsiglay);
dimid_time = netcdf.inqDimID(ncid, 'time');
[~, nt] = netcdf.inqDim(ncid, dimid_time);

if isempty(varargin)
    dye = zeros(node, nsiglay, nt);
else
    dye = varargin{:};
end



% Define the el_press variable.
varid_dye = netcdf.defVar(ncid, 'DYE', 'float', [dimid_node dimid_nsiglay dimid_time]);
netcdf.putAtt(ncid, varid_dye, 'long_name', 'DYE concentration');
netcdf.putAtt(ncid, varid_dye, 'units', '');

% End define mode
netcdf.endDef(ncid);

% Write data into the output NC file.
for it = 1 : nt
    netcdf.putVar(ncid, varid_dye,[0 0 it-1],[node nsiglay 1],dye(:,:, it));
end
% Close the output NC file.
netcdf.close(ncid);
