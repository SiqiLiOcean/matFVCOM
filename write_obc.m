%==========================================================================
% Write OBC input file
% 
% Input  : --- fobc, output OBC file path and name
%          --- obc_nodes, OBC node id
%          --- obc_type, OBC node type
%                           0 for prescribed elevation (Julian/non-Julian)
%                           1 for the radiation condition
%
% Output : \
% 
% Usage  : write_obc(fobc, obc_nodes, obc_type);
%
% v1.0
%
% Siqi Li
% 2021-04-21
%
% Updates:
%
%==========================================================================
function write_obc(fobc, obc_nodes, obc_type)

nobc = length(obc_nodes);

if nobc~=length(obc_type)
    error('obc_nodes should be in the same length of obc_type')
end

if sum(ismember(obc_type, [0,1]))~=nobc
    error('obc_type should be either 0 or 1.')
end

fid = fopen(fobc, 'w');

fprintf(fid, '%s\n', ['OBC Node Number = ' num2str(nobc)]);

for i = 1 : nobc
    fprintf(fid, '%8d %8d %8d\n', i, obc_nodes(i), obc_type(i));
end

fclose(fid);
