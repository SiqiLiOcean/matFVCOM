%==========================================================================
% Read the FVCOM dep input file (ASCII)
%
% input  : dep path and name
% output : x  (x coordinate)
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
% 2020-06-25
%==========================================================================
function [x, y, dep] = read_dep(finput)

fid=fopen(finput);

% Read the node number
line=textscan(fid,'%s %s %s %d',1);
node=line{4};

% Read the coordinate
data=textscan(fid,'%f %f %f',node);
x=cell2mat(data(:,1));
y=cell2mat(data(:,2));
dep=cell2mat(data(:,3));

fclose(fid);


fprintf('==========================================\n')
fprintf(' Reading the %s \n', finput)
fprintf(' node #: %d \n', node)
fprintf(' dep range: %f ~ %f \n', min(dep), max(dep))
fprintf(' x range: %f ~ %f \n', min(x), max(x))
fprintf(' y range: %f ~ %f \n', min(y), max(y))
