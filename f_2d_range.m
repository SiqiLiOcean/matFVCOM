%==========================================================================
% Get the FVCOM grid domain range
%
% Input  : --- fgrid, FVCOOM grid cell
%
% Output : \
%
% Usage  : f_axis_tight(f);
%
% v1
%
% Siqi Li
% 2021-05-11
%
% Updates:
%
%==========================================================================

function varargout = f_2d_range(fgrid, varargin)

varargin = read_varargin(varargin, {'Coordinate'}, {'xy'});


switch lower(Coordinate)
    case 'xy'
        xlims = [min(fgrid.x) max(fgrid.x)];
        ylims = [min(fgrid.y) max(fgrid.y)];
    case 'geo'
        xlims = [min(fgrid.LON) max(fgrid.LON)];
        ylims = [min(fgrid.LAT) max(fgrid.LAT)];
end

if strcmp(fgrid.type, 'Global')
    ylims = [-90 90];
    xlims = [fgrid.MaxLon-360 fgrid.MaxLon];
end

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

