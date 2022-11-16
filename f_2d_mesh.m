%==========================================================================
% Draw 2d fvcom mesh
%
% input  : x   (x coordinate)
%          y   (y coordinate)
%          nv  (triangle matrix)
%          (The variables above will be got from fgrid)
%          varargin (the rest settings for the patch)
% output : h (figure handle)
%
% Siqi Li, SMAST
% 2020-07-16
%==========================================================================
function h = f_2d_mesh(fgrid, varargin)


varargin = read_varargin(varargin, {'Color'}, {'k'});
varargin = read_varargin2(varargin, {'Global'});

x = fgrid.x;
y = fgrid.y;
nv = fgrid.nv;


if Global
    edge_cell = find(max(x(nv), [], 2) - min(x(nv), [], 2)>181);
    nv(edge_cell, :) = [];
end

h = patch('Vertices',[x,y], 'Faces',nv, 'FaceColor','k','FaceAlpha',0, 'EdgeColor', Color);


% i = 1;
% while i<=length(varargin)
%     switch lower(varargin{i})
%         case 'color'
%             c = varargin{i+1};
%             switch class(varargin{i+1})
%                 case 'char'
%                     if strcmp(varargin{i+1}, 'w') || strcmp(varargin{i+1}, 'white')
%                         c = [254 254 254]/255;
%                     end
%                 case 'double'
%                     if varargin{i} == [1 1 1]
%                         c = [254 254 254]/255;
%                     end
%             end
%             set(h, 'EdgeColor', c)
%             varargin(i:i+1) = [];
%             i = i - 2;
%             
%     end
%             
%     i = i + 2;
% end

if (~isempty(varargin))
    set(h, varargin{:});
end