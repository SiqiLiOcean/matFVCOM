%==========================================================================
% matFVCOM package
%   Extract cells from the FVCOM grid
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% 2024-01-22
%
% Updates:
%
%==========================================================================
function f2 = f_grid_extr_cell(f1, extr_cell)

x1 = f1.x;
y1 = f1.y;
nv1 = f1.nv;
h1 = f1.h;


%
x2 = x1;
y2 = y1;
nv2 = nv1;
h2 = h1;

% Extract the cells
nv2 = nv2(extr_cell, :);

% Extract the nodes
extr_node = unique(nv2(:));
x2 = x2(extr_node);
y2 = y2(extr_node);
h2 = h2(extr_node);

% Update the node id in nv
data = nan(length(x1), 1);
data(extr_node) = 1;
match = nan(length(x1), 1);
for i = 1 : length(x1)
    match(i) = sum(~isnan(data(1:i)));
end
nv2 = match(nv2);

f2 = f_load_grid(x2, y2, nv2, h2);
