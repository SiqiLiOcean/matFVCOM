%==========================================================================
% Read the FVCOM spg input file (ASCII)
%
% input  : spg path and name
% output : spg_node  --- sponge center node id
%          spg_R     --- sponge layer's affecting radius
%          spg_f     --- Dampng coefficient 
%          
% spg file format:
% Sponge Node Number = 5
%   1   20000  0.01
%   2   20000  0.01
%   3   20000  0.01
%   4   20000  0.01
%   5   20000  0.01
%  ...
%
%
% Siqi Li, SMAST
% 2022-12-01
%==========================================================================
function [spg_node, spg_R, spg_f] = read_spg(finput)

fid=fopen(finput);

% Read the node number
line=textscan(fid,'%s %s %s %s %d',1);
n=line{5};

if n > 0
    % Read the coordinate
    data=textscan(fid,'%d %f %f', n);
    spg_node = cell2mat(data(:,1));
    spg_R    = cell2mat(data(:,2));
    spg_f    = cell2mat(data(:,3));
        
else
    spg_node = [];
    spg_R = [];
    spg_f = [];
end

fclose(fid);

fprintf('==========================================\n')
fprintf(' Reading the %s \n', finput)
fprintf(' Sponge node #: %d \n', n)
for i = 1 : n
    fprintf('%16d %16.8f %16.8f\n', spg_node(i), spg_R(i), spg_f(i));
end

