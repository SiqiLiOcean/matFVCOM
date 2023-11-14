%==========================================================================
% Write the FVCOM lonlat input file (ASCII)
%
% input  : foutput (lonlat path and name)
%          lon  (lon coordinate)
%          lat  (lat coordinate)
%          
% dep file format:
% Node Number = 32709
%       -73.2533490    45.1440438
%       -73.2509108    45.1431603
%  ...
%
%
% Siqi Li, SMAST
% 2023-11-13
%==========================================================================
function write_lonlat(fout, lon, lat)

% Get the dimension
node = length(lon);

% Create the new file.
fid=fopen(fout, 'w');

% Write the node number
fprintf(fid, '%s %d\n', 'Node Number =  ', node);

% Write the coordinate
for i = 1 : node
    fprintf(fid, '%16.8f %16.8f\n', lon(i), lat(i));
end

% Close the file.
fclose(fid);
