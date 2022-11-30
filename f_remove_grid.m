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
function fgrid2 = f_remove_grid(fgrid, xv, yv)

if length(xv)==2 && length(yv)==2
    xlims = xv;
    ylims = yv;
    xv = [xlims(1) xlims(2) xlims(2) xlims(1) xlims(1)];
    yv = [ylims(1) ylims(1) ylims(2) ylims(2) ylims(1)];
end


x1 = fgrid.x;
y1 = fgrid.y;
nv1 = fgrid.nv;
% xc1 = fgrid.xc;
% yc1 = fgrid.yc;
% node1 = fgrid.node;
% nele1 = fgrid.nele;



[in, on] = inpolygon(x1, y1, xv, yv);

% node_removed = find(in & ~on);
node_kept = find(~(in & ~on));

% cell_kept = (sum(ismember(nv1, node_kept), 2) >= 2);
cell_kept = find(sum(ismember(nv1, node_kept), 2) == 3);

nv2 = nv1(cell_kept, :);

fgrid2 = f_load_grid(x1, y1, nv2);
