%==========================================================================
% Read the FVCOM obc input file (ASCII)
%
% input  : obc path and name
% output : obc  
%          obc_type  
%          
% obc file format:
% OBC Node Number = 111
%        1        2        1
%        2        3        1
%        3        4        1
%        4        5        1
%        5        6        1
%        6        7        1
%        7        8        1
%        8        9        1
%        9       10        1
%
% Siqi Li, SMAST
% 2020-06-25
%==========================================================================
function [obc, obc_type] = read_obc(finput)


fid=fopen(finput);

% Read the obc number
line=textscan(fid,'%s %s %s %s %d',1);
nobc = line{5};

% Read the data
data=textscan(fid,'%d %d %d',nobc);
obc = data{2};
obc_type = data{3};

fclose(fid);


fprintf('==========================================\n')
fprintf(' Reading the %s \n', finput)
fprintf(' OBC node #: %d \n', nobc)
