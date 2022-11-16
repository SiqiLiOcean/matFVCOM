%==========================================================================
% Write the FVCOM cor input file (ASCII)
%
% input  : foutput (cor path and name)
%          x  (x coordinate)
%          y  (y coordinate)
%          cor (triangle matrix)
%          
% dep file format:
% Node Number = 32709
%       -73.2533490    45.1440438    45.1440438
%       -73.2509108    45.1431603    45.1431603
%  ...
%
%
% Siqi Li, SMAST
% 2020-07-23
%==========================================================================
function write_cor(foutput, x, y, cor)

% Get the dimension
node = length(cor);

% Create the new file.
fid=fopen(foutput, 'w');

% Write the node number
fprintf(fid, '%s %d\n', 'Node Number =  ', node);

% Write the coordinate
for i = 1 : node
    fprintf(fid, '%16.8f %16.8f %16.8f\n', x(i), y(i), cor(i));
end

% Close the file.
fclose(fid);
