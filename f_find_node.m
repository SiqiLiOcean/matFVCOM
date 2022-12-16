%==========================================================================
%
%
% input  :
%
% output :
%
% Siqi Li, SMAST
% 2021-09-17
%
% Updates:
%
%==========================================================================
function [n, d] = f_find_node(fgrid, x0, y0, varargin)

% varargin = read_varargin2(varargin, {'Extrap'});



% Nearest node
[n, d] = knnsearch([fgrid.x fgrid.y], [x0(:) y0(:)]);

% if isempty(Extrap)
%     in = inpolygon([fgrid.bdy_x{:}], [fgrid.bdy_y{:}], x0, y0);
%     n(~in) = nan;
%     d(~in) = nan;
% end

