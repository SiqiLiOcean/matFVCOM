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
function h = f_2d_cell(fgrid, cell, varargin)

varargin = read_varargin(varargin, {'Color'}, {'b'});

h = patch('Vertices',[fgrid.x,fgrid.y], 'Faces',fgrid.nv(cell,:), ...
         'FaceColor',Color, 'FaceAlpha',0.5, ...
         'EdgeColor',Color, 'EdgeAlpha',0.5);

if (~isempty(varargin))
    set(h, varargin{:});
end