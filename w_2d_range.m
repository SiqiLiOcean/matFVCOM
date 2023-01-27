%==========================================================================
% Get the WRF grid domain range
%
% Input  : --- fgrid, WRF grid cell
%
% Output : \
%
% Usage  : w_axis_tight(w);
%
% v1
%
% Siqi Li
% 2021-05-11
%
% Updates:
%
%==========================================================================

function varargout = w_2d_range(varargin)

x = [];
y = [];
for i = 1 : length(varargin)
    x = [x; varargin{i}.x(:)];
    y = [y; varargin{i}.y(:)];
end
xlims = [min(x) max(x)];
ylims = [min(y) max(y)];

switch nargout 
    case 0
        axis equal
        axis([xlims ylims])
    case 1
        varargout{1} = [xlims ylims];
    case 2
        varargout{1} = xlims;
        varargout{2} = ylims;
    otherwise
        error('Too many outputs.')
end

end

