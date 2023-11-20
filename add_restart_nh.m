%==========================================================================
% Add non-hydrostatic variables in the restart file.
% 
% Input  : --- fin, original input nesting file
%          --- fout, the new nesting file with center variables included
%
% Output : \
% 
% Usage  : add_restart_nh(fin, fout);
%
% v1.0
%
% Siqi Li
% 2021-04-21
%
% Updates:
%
%==========================================================================
function add_restart_nh(fin, fout)

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
dimid_nele = netcdf.inqDimID(ncid, 'nele');
[~, nele] = netcdf.inqDim(ncid, dimid_nele);
dimid_siglev = netcdf.inqDimID(ncid, 'siglev');
[~, siglev] = netcdf.inqDim(ncid, dimid_siglev);
dimid_siglay = netcdf.inqDimID(ncid, 'siglay');
[~, siglay] = netcdf.inqDim(ncid, dimid_siglay);




W4ZT = zeros(node, siglev, nt);
NHQDRX = zeros(nele, siglay, nt);
NHQDRY = zeros(nele, siglay, nt);
NHQDRZ = zeros(node, siglay, nt);
NHQ2DX = zeros(nele, nt);
NHQ2DY = zeros(nele, nt);





% Define the W4ZT variable.
varid_W4ZT = netcdf.defVar(ncid, 'W4ZT', 'float', [dimid_node dimid_siglev dimid_time]);
netcdf.putAtt(ncid, varid_W4ZT, 'long_name', 'Temp Vertical Velocity in Z');
netcdf.putAtt(ncid, varid_W4ZT, 'units', 'meters s-1');
% Define the NHQDRX variable.
varid_NHQDRX = netcdf.defVar(ncid, 'NHQDRX', 'float', [dimid_nele dimid_siglay dimid_time]);
netcdf.putAtt(ncid, varid_NHQDRX, 'long_name', 'Nonhydrostatic Pressure Gradient XCor');
netcdf.putAtt(ncid, varid_NHQDRX, 'units', 'N M-3');
% Define the NHQDRY variable.
varid_NHQDRY = netcdf.defVar(ncid, 'NHQDRY', 'float', [dimid_nele dimid_siglay dimid_time]);
netcdf.putAtt(ncid, varid_NHQDRY, 'long_name', 'Nonhydrostatic Pressure Gradient YCor');
netcdf.putAtt(ncid, varid_NHQDRY, 'units', 'N M-3');
% Define the NHQDRZ variable.
varid_NHQDRZ = netcdf.defVar(ncid, 'NHQDRZ', 'float', [dimid_node dimid_siglay dimid_time]);
netcdf.putAtt(ncid, varid_NHQDRZ, 'long_name', 'Nonhydrostatic Pressure Gradient ZCor');
netcdf.putAtt(ncid, varid_NHQDRZ, 'units', 'N M-3');
% Define the NHQ2DX variable.
varid_NHQ2DX = netcdf.defVar(ncid, 'NHQ2DX', 'float', [dimid_nele dimid_time]);
netcdf.putAtt(ncid, varid_NHQ2DX, 'long_name', 'Nonhydrostatic Pressure Gradient XCor 2D');
netcdf.putAtt(ncid, varid_NHQ2DX, 'units', 'N M-3');
% Define the NHQ2DY variable.
varid_NHQ2DY = netcdf.defVar(ncid, 'NHQ2DY', 'float', [dimid_nele dimid_time]);
netcdf.putAtt(ncid, varid_NHQ2DY, 'long_name', 'Nonhydrostatic Pressure Gradient YCor 2D');
netcdf.putAtt(ncid, varid_NHQ2DY, 'units', 'N M-3');


% End define mode
netcdf.endDef(ncid);

% Write data into the output NC file.
for it = 1 : nt
    netcdf.putVar(ncid, varid_W4ZT, [0 0 it-1], [node siglev 1], W4ZT(:, :, it));
    netcdf.putVar(ncid, varid_NHQDRX, [0 0 it-1], [nele siglay 1], NHQDRX(:, :, it));
    netcdf.putVar(ncid, varid_NHQDRY, [0 0 it-1], [nele siglay 1], NHQDRY(:, :, it));
    netcdf.putVar(ncid, varid_NHQDRZ, [0 0 it-1], [node siglay 1], NHQDRZ(:, :, it));
    netcdf.putVar(ncid, varid_NHQ2DX, [0 it-1], [nele 1], NHQ2DX(:, it));
    netcdf.putVar(ncid, varid_NHQ2DY, [0 it-1], [nele 1], NHQ2DY(:, it));
end

% Close the output NC file.
netcdf.close(ncid);
