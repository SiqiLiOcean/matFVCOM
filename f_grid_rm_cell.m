%==========================================================================
% matFVCOM package
%   Delete cells from the FVCOM grid
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
function f2 = f_grid_rm_cell(f1, rm_cell, varargin)

x1 = f1.x;
y1 = f1.y;
nv1 = f1.nv;
h1 = f1.h;


%
x2 = x1;
y2 = y1;
nv2 = nv1;
h2 = h1;

% Remove cells
nv2(rm_cell, :) = [];

% 
rm_node = find(~ismember(1:198,unique(nv2(:))));


% Remove the nodes
x2(rm_node) =[];
y2(rm_node) =[];
h2(rm_node) =[];


% Update the node id in nv
data = 1 : length(x1);
data(rm_node) = nan;
match = nan(length(x1), 1);
for i = 1 : length(x1)
    match(i) = sum(~isnan(data(1:i)));
end
nv2 = match(nv2);


f2 = f_load_grid(x2, y2, nv2, h2);
