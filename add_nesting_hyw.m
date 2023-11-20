%==========================================================================
% Add 'hyw' to the nesting boundary file
% 
% Input  : --- fin, original input nesting file
%          --- fout, the new nesting file with hyw 
%          --- hyw, hydro-static vertical velocity 
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
function add_nesting_hyw(fin, fout, hyw)


if ~strcmp(fin, fout)
    disp('Copying file.')
    copyfile(fin, fout)
    disp('Copy finished.')
end


ncid = netcdf.open(fout, 'NC_WRITE');
netcdf.reDef(ncid);

node_dimid = netcdf.inqDimID(ncid, 'node');
siglev_dimid = netcdf.inqDimID(ncid, 'siglev');
time_dimid = netcdf.inqDimID(ncid, 'time');

[~, node] = netcdf.inqDim(ncid, node_dimid);
[~, kb] = netcdf.inqDim(ncid, siglev_dimid);
[~, nt] = netcdf.inqDim(ncid, time_dimid);
if (numel(hyw) == 1)
    hyw = hyw * ones(node, kb, nt);
end

if (size(hyw,1) ~= node) || (size(hyw,2) ~= kb) || (size(hyw,3) ~= nt)
    disp(size(hyw))
    disp([node, kb, nt])
    error('Wrong size of hyw')
end 

hyw_varid=netcdf.defVar(ncid, 'hyw', 'float', [node_dimid siglev_dimid time_dimid]);
netcdf.putAtt(ncid,hyw_varid, 'long_name', 'hydro static vertical velocity');
netcdf.putAtt(ncid,hyw_varid, 'units', 'm/s');
netcdf.putAtt(ncid,hyw_varid, 'grid', 'fvcom_grid');
netcdf.putAtt(ncid,hyw_varid, 'coordinates', 'lat lon');
netcdf.putAtt(ncid,hyw_varid, 'type', 'data');

netcdf.endDef(ncid);

for it = 1 : nt
    it
    if (mod(it, 10) == 0)
        disp(['--->' num2str(it,'%6d') '/' num2str(nt,'%6d')])
    end 
    netcdf.putVar(ncid, hyw_varid, [0 0 it-1], [node kb 1], hyw(:,:,it));
end

netcdf.close(ncid);
