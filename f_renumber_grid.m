%==========================================================================
%
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% yyyy-mm-dd
%
% Updates:
%
%==========================================================================
function f2 = f_renumber_grid(f1, varargin)

% varargin = read_varargin(varargin, {'Grid'}, {[]});
varargin = read_varargin(varargin, {'Node_start'}, {[]});
varargin = read_varargin(varargin, {'Node_end'}, {[]});
varargin = read_varargin(varargin, {'Node_2nd_end'}, {[]});



if ~isempty(Node_start)
    id = knnsearch([f1.x f1.y], Node_start);
    [x, y, nv, h] = move_node('start', id, f1.x, f1.y, f1.nv, f1.h);
    f2 = f_load_grid(x, y, nv, h);
end
if ~isempty(Node_end)
    id = knnsearch([f1.x f1.y], Node_end);
    [x, y, nv, h] = move_node('end', id, f1.x, f1.y, f1.nv, f1.h);
    f2 = f_load_grid(x, y, nv, h);
end
if ~isempty(Node_2nd_end)
    id = knnsearch([f1.x f1.y], Node_2nd_end);
    [x, y, nv, h] = move_node('2nd_end', id, f1.x, f1.y, f1.nv, f1.h);
    f2 = f_load_grid(x, y, nv, h);
end


% % f0 = f;
% % Grid = {f1, f2, f3};
% % % Now we divide the whole domain into several parts:
% % for i = 1 : length(Grid)
% %     node_group{i} = unique(knnsearch([f0.x f0.y], [Grid{i}.x Grid{i}.y]))';
% %     cell_group{i} = unique(knnsearch([f0.xc f0.yc], [Grid{i}.xc Grid{i}.yc]))';
% % end
% % for i = 1 : length(Grid) - 1
% %     node_boundary{i} = intersect(node_group{i}, node_group{i+1});
% % end
% % for i = 1 : length(Grid)
% %     if i == 1
% %         node_inner{i} = setdiff(node_group{i}, node_boundary{i});
% %     elseif i == length(Grid)
% %         node_inner{i} = setdiff(node_group{i}, node_boundary{i-1});
% %     else
% %         node_inner{i} = setdiff(node_group{i}, [node_boundary{i-1} node_boundary{i}]);        
% %     end
% %     cell_inner{i} = cell_group{i};
% % end
% % node_rest = setxor(1:f0.node, [node_group{:}]);
% % cell_rest = setxor(1:f0.nele, [cell_group{:}]);
% % 
% % node_new = node_rest;

    
end

function [x2, y2, nv2, h2] = move_node(mode, id_move, x1, y1, nv1, h1)

id1 = 1 : length(x1);

switch lower(mode)
    case 'start'
        id2 = [id_move setxor(id1, id_move)];
    case 'end'
        id2 = [setxor(id1, id_move) id_move];
    case '2nd_end'
        tmp = setxor(id1, id_move);
        id2 = [tmp(1:end-1) id_move tmp(end)];
    otherwise
        error('Use start or end for position')
end

x2 = x1(id2);
y2 = y1(id2);
if exist('h1', 'var')
    h2 = h1(id2);
else
    h2 = nan * x1;
end

[~, node_match] = sort(id2);
nv2 = node_match(nv1);

end

