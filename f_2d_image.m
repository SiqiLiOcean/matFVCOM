%==========================================================================
% Draw 2d image for fvcom-grid variables
%
% input  : x   (x coordinate)
%          y   (y coordinate)
%          nv  (triangle matrix)
%          (The variables above will be got from fgrid)
%          var (the drawn variable)  --- (node, 1), draw variable on node
%                                    --- (nele, 1), draw variable on nele
%          varargin (the rest settings for the patch)
% output : h (figure handle)
%
% Siqi Li, SMAST
% 2020-07-16
%==========================================================================
function h = f_2d_image(fgrid, var, varargin)

% varargin = read_varargin2(varargin, {'Global'});
varargin = read_varargin(varargin, {'MaxLon'}, {fgrid.MaxLon});
MinLon = MaxLon - 360.;
MidLon = MaxLon - 180.;

x = fgrid.x;
y = fgrid.y;
nv = fgrid.nv;

node = fgrid.node;
nele = fgrid.nele;

switch length(var) 
    case node
    case nele
        var = f_interp_cell2node(fgrid, var(:));
    otherwise
        error('Wrong size of variable.')
end

if strcmp(fgrid.type, 'Global')
    Pole_node = find(y==90.);
%     edge_cell = find(max(x(nv), [], 2) - min(x(nv), [], 2)>181);
    % Find the cells crossed by the boundary line
    max_cell_x = max(x(nv), [], 2);
    min_cell_x = min(x(nv), [], 2);
    edge_cell = (max_cell_x>MidLon & min_cell_x<MidLon & max_cell_x-min_cell_x>180.);

    edge_nv = nv(edge_cell,:);
    edge_node = setdiff(unique(edge_nv), Pole_node);
    
    edge_x = x(edge_node);
    k1 = find(edge_x < MidLon);
    k2 = find(edge_x > MidLon);
    edge_x(k1) = edge_x(k1) + 360.;
    edge_x(k2) = edge_x(k2) - 360.;
    edge_y = y(edge_node);
    edge_nv_right = changem(edge_nv, k1+node, edge_node(k1));
    edge_nv_left = changem(edge_nv, k2+node, edge_node(k2));
    
    
    x = [x; edge_x];
    y = [y; edge_y];
    nv = [nv(~edge_cell, :); edge_nv_right; edge_nv_left];
%     switch length(var)
%         case node
            var = [var; var(edge_node)];
%         case nele
%             var = [var(~edge_cell); var(edge_cell); var(edge_cell)];
%     end
    xlim([MinLon MaxLon])
    ylim([-90 90])
end

% 
h = patch('Vertices',[x,y], 'Faces',nv, 'FaceColor','interp', 'FaceVertexCData',var(:), 'EdgeColor','none');


if (~isempty(varargin))
    set(h, varargin{:});
end