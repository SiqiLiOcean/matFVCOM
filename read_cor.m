%==========================================================================
% Read the FVCOM cor input file (ASCII)
%
% input  : cor path and name
% output : cor (triangle matrix)
%          x  (x coordinate)
%          y  (y coordinate)
%          
% dep file format:
% Node Number = 32709
%       -73.2533490    45.1440438    35.00
%       -73.2509108    45.1431603    35.00
%  ...
%
% **** positive cor means degree N
%
% Siqi Li, SMAST
% 2020-06-25
%==========================================================================
function [cor, x, y] = read_cor(finput)

fid=fopen(finput);

% Read the node number
line=textscan(fid,'%s %s %s %d',1);
node=line{4};

% Read the coordinate
data=textscan(fid,'%d %f %f',node);
x=cell2mat(data(:,1));
y=cell2mat(data(:,2));
cor=cell2mat(data(:,3));

fclose(fid);


fprintf('==========================================\n')
fprintf(' Reading the %s \n', finput)
fprintf(' node #: %d \n', node)
fprintf(' cor range: %f ~ %f \n', min(cor), max(cor))
fprintf(' x range: %f ~ %f \n', min(x), max(x))
fprintf(' y range: %f ~ %f \n', min(y), max(y))
