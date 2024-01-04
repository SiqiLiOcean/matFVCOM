%==========================================================================
% matFVCOM package
%   Delete nodes from the FVCOM grid
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% 2024-01-04
%
% Updates:
%
%==========================================================================
function f2 = f_grid_rm_node(f1, rm_node, varargin)

x1 = f1.x;
y1 = f1.y;
nv1 = f1.nv;
h1 = f1.h;

%
x2 = x1;
y2 = y1;
nv2 = nv1;
h2 = h1;

rm_cell = find(sum(ismember(nv1, rm_node), 2));

data = 1 : length(x1);
data(rm_node) = nan;
match = nan(length(x1), 1);
for i = 1 : length(x1)
    match(i) = sum(~isnan(data(1:i)));
end



% Remove the nodes
x2(rm_node) =[];
y2(rm_node) =[];
h2(rm_node) =[];

% Remove the cells
nv2(rm_cell,:) = [];

% Update the node id in nv
nv2 = match(nv2);



f2 = f_load_grid(x2, y2, nv2, h2);





