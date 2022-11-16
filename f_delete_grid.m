%==========================================================================
% Delete a part of grid from the original one
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% 2021-11-02
%
% Updates:
%
%==========================================================================
function fgrid2 = f_delete_grid(fgrid, xv, yv)

if length(xv)==2 && length(yv)==2
    xlims = xv;
    ylims = yv;
    xv = [xlims(1) xlims(2) xlims(2) xlims(1) xlims(1)];
    yv = [ylims(1) ylims(1) ylims(2) ylims(2) ylims(1)];
end


x1 = fgrid.x;
y1 = fgrid.y;
nv1 = fgrid.nv;


[in, on] = inpolygon(x1, y1, xv, yv);

node_kept = find(~(in & ~on));
cell_kept = find(sum(ismember(nv1, node_kept), 2) == 3);

nv2 = nv1(cell_kept, :);

fgrid2 = f_load_grid(x1, y1, nv2);

fgrid2 = f_check_grid(fgrid2);
