%==========================================================================
% Add 'hyw' to the nesting boundary file
% 
% Input  : --- fin, original input nesting file
%          --- fout, the new nesting file with hyw (optional)
%          --- hyw, hydro-static vertical velocity (optional)
%
% Output : \
% 
% Usage  : add_nesting_hyw(fin, fout);
%
% v1.0
%
% Siqi Li
% 2021-04-21
%
% Updates:
%
%==========================================================================
function add_nesting_hyw(fin, fout, varargin)

varargin = read_varargin(varargin, {'hyw'}, {0});

if exist('fout', 'var')
    copyfile(fin, fout);
else
    fout = fin;
end

% f = f_load_grid(fout, 'xy');


ncid = netcdf.open(fout, 'NC_WRITE');
netcdf.reDef(ncid);

node_dimid = netcdf.inqDimID(ncid, 'node');
siglev_dimid = netcdf.inqDimID(ncid, 'siglev');
time_dimid = netcdf.inqDimID(ncid, 'time');

if (numel(hyw) == 1)
    [~, node] = netcdf.inqDim(ncid, node_dimid);
    [~, kb] = netcdf.inqDim(ncid, siglev_dimid);
    [~, nt] = netcdf.inqDim(ncid, time_dimid);
    hyw = zeros(node, kb, nt);
end

hyw_varid=netcdf.defVar(ncid, 'hyw', 'float', [node_dimid siglev_dimid time_dimid]);
netcdf.putAtt(ncid,hyw_varid, 'long_name', 'hydro static vertical velocity');
netcdf.putAtt(ncid,hyw_varid, 'units', 'm/s');
netcdf.putAtt(ncid,hyw_varid, 'grid', 'fvcom_grid');
netcdf.putAtt(ncid,hyw_varid, 'coordinates', 'lat lon');
netcdf.putAtt(ncid,hyw_varid, 'type', 'data');

netcdf.endDef(ncid);

for it = 1 : nt
    netcdf.putVar(ncid, hyw_varid, [1 1 it-1], [Inf Inf 1], hyw(:,:,it));
end

netcdf.close(ncid);
