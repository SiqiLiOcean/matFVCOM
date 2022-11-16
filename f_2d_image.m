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

varargin = read_varargin2(varargin, {'Global'});



x = fgrid.x;
y = fgrid.y;
nv = fgrid.nv;

node = fgrid.node;
nele = fgrid.nele;


if Global
    edge_cell = find(max(x(nv), [], 2) - min(x(nv), [], 2)>181);
    nv(edge_cell, :) = [];
end

% 
switch length(var)
    case node
        h = patch('Vertices',[x,y], 'Faces',nv, 'FaceColor','interp', 'FaceVertexCData',var(:), 'EdgeColor','none');
    case nele
%         h = patch('Vertices',[x,y], 'Faces',nv, 'FaceColor','flat', 'FaceVertexCData',var(:), 'EdgeColor','none');
        var = f_interp_cell2node(fgrid, var(:));
        h = patch('Vertices',[x,y], 'Faces',nv, 'FaceColor','interp', 'FaceVertexCData',var(:), 'EdgeColor','none');
    otherwise
        error('Wrong size of input variable.')
end

if (~isempty(varargin))
    set(h, varargin{:});
end