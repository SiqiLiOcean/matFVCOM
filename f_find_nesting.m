%==========================================================================
% Find the n-layer nodes and cells for nesting boundary 
%
%            ------------------------node_layer{3}
%           /\    /\    /\    /
%          /  \  /  \  /  \  /       cell_layer{2}
%         /    \/    \/    \/
%        ----------------------------node_layer{2}
%       /\    /\    /\    /
%      /  \  /  \  /  \  /           cell_layer{1}
%     /    \/    \/    \/
%    --------------------------------node_layer{1} (obc)
%
% input  :
%   fgrid    --- fvcom grid
%   obc_node --- open boundary node id
%   nlayer   --- layer number of nesting cells
% 
% output :
%   node_layer --- node id of each layer (totally nlayer+1 layers)
%   cell_layer --- cell id of each layer (totally nlayer layers)
%
% To get all the node/cell ids of the whole nesting layers:
%    node_nesting = [node_layer{:}];
%    cell_nesting = [cell_layer{:}];
%    node_weight = [weight_node{:}];
%    cell_weight = [weight_cell{:}];
%
% Siqi Li, SMAST
% 2022-11-01
%
% Updates:
%
%==========================================================================
function [node_layer, cell_layer, weight_node, weight_cell] = f_find_nesting(fgrid, obc_node, nlayer, varargin)
% 
% fgrid = f_load_grid(fin);
% obc_node = 1 : 130;
% nlayer = 7;
varargin = read_varargin(varargin, {'Node_weight'}, {((nlayer+1):-1:1)/(nlayer+1)});
varargin = read_varargin(varargin, {'Cell_weight'}, {(nlayer:-1:1)/nlayer});


nv = fgrid.nv;

node_layer{1} = obc_node(:)';
weight_node{1} = node_layer{1}*0 + Node_weight(1);
for i = 1 : nlayer
    tmp = find(any(ismember(nv, node_layer{i}),2));
    if i>1
        tmp = setdiff(tmp, [cell_layer{1:i-1}]);
    end
    cell_layer{i} = tmp(:)';
    weight_cell{i} = double(cell_layer{i})*0 + Cell_weight(i);

    all_node = unique(nv(cell_layer{i},:));
    tmp = setdiff(all_node, [node_layer{1:i}]);
    node_layer{i+1} = tmp(:)';
    weight_node{i+1} = double(node_layer{i+1})*0 + Node_weight(i+1);
end


