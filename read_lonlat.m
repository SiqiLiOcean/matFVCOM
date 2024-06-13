%==========================================================================
% Read the FVCOM lonlat input file (ASCII)
%
% input  : lonlat path and name
% output : lon  
%          lat  
%          
% dep file format:
% Node Number = 32709
%       -73.2533490    45.1440438   
%       -73.2509108    45.1431603  
%  ...
%
% Siqi Li, SMAST
% 2020-06-25
%==========================================================================
function [x, y] = read_lonlat(finput)

fid=fopen(finput);

% Read the node number
line=textscan(fid,'%s %s %s %d',1);
node=line{4};

% Read the coordinate
data=textscan(fid,'%f %f',node);
x=cell2mat(data(:,1));
y=cell2mat(data(:,2));

fclose(fid);
