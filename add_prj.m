function add_prj(fshp)

fprj = fshp;
fprj(end-2:end) = 'prj';
fid = fopen(fprj, 'w');
fprintf(fid, '%s\n', 'GEOGCS["GCS_WGS_1984",DATUM["D_WGS_1984",SPHEROID["WGS_1984",6378137.0,298.257223563]],PRIMEM["Greenwich",0.0],UNIT["Degree",0.0174532925199433]]');
fclose(fid);