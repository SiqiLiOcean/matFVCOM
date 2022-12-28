%==========================================================================
% Write the FVCOM dep input file (ASCII)
%
% input  : foutput (dep path and name)
%          x  (x coordinate)
%          y  (y coordinate)
%          dep (triangle matrix)
%          
% dep file format:
% Node Number = 32709
%       -73.2533490    45.1440438    2.109
%       -73.2509108    45.1431603    4.365
%  ...
%
% **** positive depth means water depth in ocean
%
% Siqi Li, SMAST
% 2020-07-16
%==========================================================================
function write_dep(fout, x, y, dep)

% Get the dimension
node = length(dep);

% Create the new file.
fid=fopen(fout, 'w');

% Write the node number
fprintf(fid, '%s %d\n', 'Node Number =  ', node);

% Write the coordinate
for i = 1 : node
    fprintf(fid, '%16.8f %16.8f %16.2f\n', x(i), y(i), dep(i));
end

% Close the file.
fclose(fid);
