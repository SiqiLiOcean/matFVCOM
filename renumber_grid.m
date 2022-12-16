%==========================================================================
% Renumber the grid node id
%
% input  : nv --- id of nodes around cells, (nele, 3)
%          id --- node index
% 
% output : nv_rew --- nv with renumbered nodes
%
% Siqi Li, SMAST
% 2021-06-15
%
% Updates:
%
%==========================================================================
function nv_new = renumber_grid(nv, id)

% nv = nv2;
% id = id2;

node = length(unique(nv));
% nele = size(nv, 1);

m = max(id);


if m==node
    disp('No gap was found in the index of nodes and cells.')
    disp('Nothing was done.')
    nv_new = nv;
    return
end


id_match = nan(m,1);

id_match(id) = 1 : node;

nv_new = id_match(nv);


    
    
