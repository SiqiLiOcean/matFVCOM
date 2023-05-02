%==========================================================================
% Write the FVCOM lsf input file (ASCII)
%
% input  : foutput      --- lsf path and name
%          lsf_node_1st --- 1st array node id
%          lsf_node_2nd --- 2nd array node id
%          lsf_geo      --- thermal wind flow adjusting scaling in a range of [0 1]
%          lsf_wdf      --- wind driven flow adjusting scaling in a range of [0 1]
%          
% lsf file format:
% Longshore Flow Node Number =   23
% # NODES MUST BE LISTED IN THE OFFSHORE DIRECTION
% #     NODE(1st) NODE(2nd)  GEO       WD
%   1        1      260      1.0      0.5
%   2        2      259      1.0      0.2
%   3        3      258      1.0      0.0
%   4        4      257      1.0      0.0
%   5        5      256      1.0      0.0
%  ...
%
%
% Siqi Li, SMAST
% 2021-12-01
%==========================================================================
function write_lsf(fout, lsf_node_1st, lsf_node_2nd, lsf_geo, lsf_wdf)



%% Find out the related cells
%lsf_cell = find(all(ismember(fgrid.nv, [lsf_node_1st(:); lsf_node_2nd(:)]), 2));

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
