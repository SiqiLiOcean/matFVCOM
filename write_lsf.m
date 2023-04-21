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
function [lsf_node_2nd, lsf_cell] = write_lsf(fout, fgrid, lsf_node_1st, lsf_node_2nd, lsf_geo, lsf_wdf)



% Find out the related cells
lsf_cell = find(all(ismember(fgrid.nv, [lsf_node_1st(:); lsf_node_2nd(:)]), 2));

m = length(lsf_node_1st);



% Create the new file.
fid=fopen(fout, 'w');

% Write the node number
fprintf(fid, '%s %d\n', 'Longshore Flow Node Number =  ', m);
fprintf(fid, '%s\n', '# NODES MUST BE LISTED IN THE OFFSHORE DIRECTION');
fprintf(fid, '%s\n', '#     NODE(1st) NODE(2nd)  GEO       WD');


% Write the data of nodes
for i = 1 : m
    fprintf(fid, '%3d %8d %8d %8.1f %8.1f\n', i, lsf_node_1st(i), lsf_node_2nd(i), lsf_geo(i), lsf_wdf(i));
end

% Close the file.
fclose(fid);
