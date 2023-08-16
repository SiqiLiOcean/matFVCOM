%==========================================================================
% Write OBC input file
% 
% Input  : --- fobc, output OBC file path and name
%          --- obc_node, OBC node id
%          --- obc_type, OBC node type
%                           0 for prescribed elevation (Julian/non-Julian)
%                           1 for the radiation condition
% ! TYPE_OBC = 1: Surface Elevation Specified (Tidal Forcing) (ASL)              !
% ! TYPE_OBC = 2: AS TYPE_OBC=1 AND NON-LINEAR FLUX FOR CURRENT AT OPEN BOUNDARY !
% ! TYPE_OBC = 3: Zero Surface Elevation Boundary Condition (ASL_CLP)            !
% ! TYPE_OBC = 4: AS TYPE_OBC=3 AND NON-LINEAR FLUX FOR CURRENT AT OPEN BOUNDARY !
% ! TYPE_OBC = 5: GRAVITY-WAVE RADIATION IMPLICIT OPEN BOUNDARY CONDITION (GWI)  !
% ! TYPE_OBC = 6: AS TYPE_OBC=5 AND NON-LINEAR FLUX FOR CURRENT AT OPEN BOUNDARY !
% ! TYPE_OBC = 7: BLUMBERG AND KHANTA IMPLICIT OPEN BOUNDARY CONDITION (BKI)     !
% ! TYPE_OBC = 8: AS TYPE_OBC=7 AND NON-LINEAR FLUX FOR CURRENT AT OPEN BOUNDARY !
% ! TYPE_OBC = 9: ORLANSKI RADIATION EXPLICIT OPEN BOUNDARY CONDITION (ORE)      !
% ! TYPE_OBC =10: AS TYPE_OBC=9 AND NON-LINEAR FLUX FOR CURRENT AT OPEN BOUNDARY !
% 
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
function write_obc(fobc, obc_node, obc_type)

nobc = length(obc_node);

if length(obc_type)==1
    obc_type = obc_node*0 + obc_type;
end

if nobc~=length(obc_type)
    error('obc_nodes should be in the same length of obc_type')
end

% % % if sum(ismember(obc_type, [0,1]))~=nobc
% % %     error('obc_type should be either 0 or 1.')
% % % end

fid = fopen(fobc, 'w');

fprintf(fid, '%s\n', ['OBC Node Number = ' num2str(nobc)]);

for i = 1 : nobc
    fprintf(fid, '%8d %8d %8d\n', i, obc_node(i), obc_type(i));
end

fclose(fid);
