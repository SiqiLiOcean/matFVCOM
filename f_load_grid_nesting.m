%==========================================================================
% Create the fgrid structure of the nesting boundary
%
% input  :
%   fgrid --- the fgrid of the FVCOM domain
%   nesting_node --- ids of nesting nodes in fgrid
%   nesting_cell --- ids of nesting cells in fgrid (optional)
%                    * If not given, there might be one more cell selected
%                      at the corner.
%
% output :
%   fn    --- the fgrid of the nesting boundary
%
% Siqi Li, SMAST
% 2022-09-21
%
% Updates:
% 2022-10-16  Siqi Li  Added LON and LAT (required for nesting files)
%==========================================================================
function fn = f_load_grid_nesting(fgrid, nesting_node, nesting_cell, varargin)

varargin = read_varargin(varargin, {'Node_weight'}, {nesting_node*0+1});
varargin = read_varargin(varargin, {'Cell_weight'}, {nesting_cell*0+1});

% Generate the nesting boundary
if ~exist('nesting_cell', 'var')
    nesting_cell = find(all(ismember(fgrid.nv, nesting_node),2));
end
nesting_nv = fgrid.nv(nesting_cell, :);
match_node = nan(fgrid.node, 1);
for i = 1 : length(nesting_node)
    match_node(nesting_node(i)) = i;
end
nesting_nv = match_node(nesting_nv);

fn = f_load_grid(fgrid.x(nesting_node), ...
                 fgrid.y(nesting_node), ...
                 nesting_nv, ...
                 fgrid.h(nesting_node), ...
                 fgrid.siglay(nesting_node, :));

if isfield(fgrid, 'LON') && isfield(fgrid, 'LAT')
    fn.LON = fgrid.LON(nesting_node);
    fn.LAT = fgrid.LAT(nesting_node);
end

fn.nesting_node = nesting_node;
fn.nesting_cell = nesting_cell;
fn.node_weight = Node_weight;
fn.cell_weight = Cell_weight;