%==========================================================================
% Add hs, tpeak, wdir in the restart file, for wave case.
% 
% Input  : --- fin, original input restart file
%          --- fout, the new restart file
%
% Output : \
% 
% Usage  : add_restart_wave(fin, fout);
%
% v1.0
%
% Siqi Li
% 2021-08-12
%
% Updates:
% 2021-08-25  Siqi Li  Add hs, tpeak, wdir as input
%==========================================================================
function add_restart_wave(fin, fout, varargin)


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


disp(['----Input Dimensions:'])
disp(['    node : ' num2str(node)])
disp(['    time : ' num2str(nt)])
read_varargin(varargin, {'hs'}, {zeros(node, nt)});
read_varargin(varargin, {'tpeak'}, {zeros(node, nt)});
read_varargin(varargin, {'wdir'}, {zeros(node, nt)});
% hs = zeros(node, nt);
% tpeak = zeros(node, nt);
% wdir = zeros(node, nt);
disp(['----Added variables:'])
disp(['    Name     Size           Range '])
disp(['    hs    :' num2str(size(hs)) '    ' num2str(range(hs))])
disp(['    tpeak :' num2str(size(tpeak)) '    ' num2str(range(tpeak))])
disp(['    wdir  :' num2str(size(wdir)) '    ' num2str(range(wdir))])



% Define the el_press variable.
% hs
varid_hs = netcdf.defVar(ncid, 'hs', 'float', [dimid_node dimid_time]);
netcdf.putAtt(ncid, varid_hs, 'long_name', 'Significant Wave Height');
netcdf.putAtt(ncid, varid_hs, 'units', 'meters');
% tpeak
varid_tpeak = netcdf.defVar(ncid, 'tpeak', 'float', [dimid_node dimid_time]);
netcdf.putAtt(ncid, varid_tpeak, 'long_name', 'Relative Peak Period');
netcdf.putAtt(ncid, varid_tpeak, 'units', 's');
% wdir
varid_wdir = netcdf.defVar(ncid, 'wdir', 'float', [dimid_node dimid_time]);
netcdf.putAtt(ncid, varid_wdir, 'long_name', 'Wave Direction');
netcdf.putAtt(ncid, varid_wdir, 'units', 'degree');

% End define mode
netcdf.endDef(ncid);

% Write data into the output NC file.
for it = 1 : nt
    netcdf.putVar(ncid, varid_hs,    [0 it-1], [node 1], hs(:, it));
    netcdf.putVar(ncid, varid_tpeak, [0 it-1], [node 1], tpeak(:, it));
    netcdf.putVar(ncid, varid_wdir,  [0 it-1], [node 1], wdir(:, it));
    
end
% Close the output NC file.
netcdf.close(ncid);

