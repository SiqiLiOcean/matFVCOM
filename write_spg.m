%==========================================================================
% Write the FVCOM spg input file (ASCII)
%
% input  : foutput   --- spg path and name
%          spg_node  --- sponge center node id
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
% 2021-12-01
%==========================================================================
function write_spg(fout, spg_node, spg_R, spg_f)


n = length(spg_node);

if length(spg_R)==1
    spg_R = spg_node*0 + spg_R;
end
if length(spg_f)==1
    spg_f = spg_node*0 + spg_f;
end


% Create the new file.
fid=fopen(fout, 'w');

% Write the node number
fprintf(fid, '%s %d\n', 'Sponge Node Number =  ', n);

% Write the coordinate
for i = 1 : n
    fprintf(fid, '%16d %16.8f %16.8f\n', spg_node(i), spg_R(i), spg_f(i));
end

% Close the file.
fclose(fid);
