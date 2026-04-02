%==========================================================================
% matFVCOM package
% 
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% 2026-03-26
%
% Updates:
%
%==========================================================================
function S = write_shape_polygon(fshp, lon, lat, varargin)


%------------------ Create the structure -------------------
for i = 1:length(lon)
    S(i).Geometry = 'Polygon';       
    S(i).Lon = lon{i}             
    S(i).Lat = lat{i};        
end

%------------------ Write the shp -------------------------
shapewrite(S, fshp);

% Write the prj file
fprj = fshp;
fprj(end-2:end) = 'prj';
fid = fopen(fprj, 'w');
fprintf(fid, '%s\n', 'GEOGCS["GCS_WGS_1984",DATUM["D_WGS_1984",SPHEROID["WGS_1984",6378137.0,298.257223563]],PRIMEM["Greenwich",0.0],UNIT["Degree",0.0174532925199433]]');
fclose(fid);