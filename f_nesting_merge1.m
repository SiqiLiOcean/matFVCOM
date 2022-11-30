%==========================================================================
%
%
% input  :
%   f     --- destination grid
%   fin   --- cell of the source grids, the last one should be for the
%             largest domain
%   bdy_x --- cell of boundary x
%   bdy_y --- cell of boundary y
% 
% output :
%
% Siqi Li, SMAST
% 2021-11-02
%
% Updates:
%
%==========================================================================
function index = f_nesting_merge1(f, fin, bdy_x, bdy_y)

if ~iscell(bdy_x)
    bdy_x = {bdy_x};
    bdy_y = {bdy_y};
end


n = length(fin);

in_node_all = zeros(f.node, 1);
in_cell_all = zeros(f.nele, 1);
for i = 1 : n-1
    
    if iscell(bdy_x{i})
        tmpx = [bdy_x{i}{:}];
        tmpy = [bdy_y{i}{:}];
    else
        tmpx = bdy_x{i};
        tmpy = bdy_y{i};
    end
    
    in_node = inpolygon(f.x, f.y, tmpx, tmpy);
    in_cell = inpolygon(f.xc, f.yc, tmpx, tmpy);
    
    inode = find(in_node);
    jnode = knnsearch([fin{i}.x, fin{i}.y], [f.x(inode), f.y(inode)]);
    
    icell = find(in_cell);
    jcell = knnsearch([fin{i}.xc, fin{i}.yc], [f.xc(icell), f.yc(icell)]);
    
    index(i).inode = inode;
    index(i).jnode = jnode;
    index(i).icell = icell;
    index(i).jcell = jcell;
    
    in_node_all = in_node_all | in_node;
    in_cell_all = in_cell_all | in_cell;
    
end

i = n;

inode = find(~in_node_all);
jnode = knnsearch([fin{i}.x, fin{i}.y], [f.x(inode), f.y(inode)]);

icell = find(~in_cell_all);
jcell = knnsearch([fin{i}.xc, fin{i}.yc], [f.xc(icell), f.yc(icell)]);

index(i).inode = inode;
index(i).jnode = jnode;
index(i).icell = icell;
index(i).jcell = jcell;