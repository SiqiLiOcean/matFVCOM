%==========================================================================
% Draw transect contour for 
%
% input  : x   (x coordinate)
%          y   (y coordinate)
%          (The variables above will be got from fgrid)
%          var  (the drawn variable)  --- (node, 1), draw variable on node
%          x0  (lon/x on transect points)
%          y0  (lat/y on transect points)
%          zlims ([min(z) max(z)])
%          varargin (the rest settings for the contour)
% output : h (figure handle)
%
% Usage:
%    
%
% Siqi Li, SMAST
% 2020-07-16
%==========================================================================

function [h, dd, zz, var_out] = f_transect_contour(fgrid, var, x0, y0, varargin)


varargin = read_varargin(varargin, ...
            {'FontSize', 'LabelSpacing', 'Color'}, ...
            {        12,            100,     'k'});
varargin = read_varargin(varargin, {'Levels'}, {[]});
varargin = read_varargin(varargin, {'LabelLevels'}, {[]});


varargin = read_varargin2(varargin, {'Manual'});     
varargin = read_varargin2(varargin, {'NoLabel'});    
varargin = read_varargin2(varargin, {'Geo'});

if length(size(var))~=2
    error('The dimension # of your VAR should be 2.')
end

[n1, n2] = size(var);
nv = fgrid.nv;
if n1==fgrid.node && n2==fgrid.kbm1
    x = fgrid.x;
    y = fgrid.y;
    z = -fgrid.deplay;
elseif n1==fgrid.node && n2==fgrid.kb
    x = fgrid.x;
    y = fgrid.y;
    z = -fgrid.deplev;
elseif n1==fgrid.nele && n2==fgrid.kbm1
    x = fgrid.x;
    y = fgrid.y;
    z = -fgrid.deplay;
    var = f_interp_cell2node(fgrid, var);
elseif n1==fgrid.nele && n2==fgrid.kb
    x = fgrid.x;
    y = fgrid.y;
    z = -fgrid.deplevc;
    var = f_interp_cell2node(fgrid, var);
else
    error('The dimensions do not match the grid')
end

varargin = read_varargin(varargin, {'npixel', 'zlims'}, {     200,      []});
varargin = read_varargin2(varargin, {'Extrap'});

% Calculate the data for the transect figure
% if Extrap && Geo
%     [dd, zz, var_out] = interp_transect('TRI', var, x, y, z, nv, x0, y0, 'zlims', zlims, 'npixel', npixel, 'Extrap', 'Geo');
% elseif Extrap && ~Geo
%     [dd, zz, var_out] = interp_transect('TRI', var, x, y, z, nv, x0, y0, 'zlims', zlims, 'npixel', npixel, 'Extrap');
% elseif ~Extrap && Geo
%     [dd, zz, var_out] = interp_transect('TRI', var, x, y, z, nv, x0, y0, 'zlims', zlims, 'npixel', npixel, 'Geo');
% else
%     [dd, zz, var_out] = interp_transect('TRI', var, x, y, z, nv, x0, y0, 'zlims', zlims, 'npixel', npixel);
% end
[dd, zz, var_out] = interp_transect('TRI', var, x, y, z, nv, x0, y0, 'zlims', zlims, 'npixel', npixel, Extrap, Geo);


% Pcolor the transect
if isempty(Levels)
    [C, h] = contour(dd, zz, var_out);
else
    [C, h] = contour(dd, zz, var_out, Levels);
end

set(h, 'linecolor', 'k')

if isempty(NoLabel)
    
    if Manual
        clabel(C, h, 'manual', ...
            'fontsize',FontSize, ...
            'Color', Color);
    else
        if isempty(LabelLevels)
            clabel(C, h, 'fontsize',FontSize, ...
                'LabelSpacing', LabelSpacing, ...
                'Color', Color);
        else
            clabel(C, h, LabelLevels, 'fontsize',FontSize, ...
                'LabelSpacing', LabelSpacing, ...
                'Color', Color);
        end
    end
end

if (~isempty(varargin))
    set(h, varargin{:});
end

% i = 1;
% while i<=length(varargin)
%     switch lower(varargin{i})
%         case 'fontsize'
%             clabel(C, h, 'fontsize', varargin{i+1});
%             varargin(i:i+1) = [];
%             i = i - 2;
%         case 'labelspacing'
%             clabel(C, h, 'labSelspacing', varargin{i+1});
%             varargin(i:i+1) = [];
%             i = i - 2;
%         case 'color'
%             set(h, 'linecolor', varargin{i+1})
%             clabel(C, h, 'color', varargin{i+1});
%             varargin(i:i+1) = [];
%             i = i - 2;
%             
%     end
%     i = i + 2;
% end


xlim([min(dd(:)) max(dd(:))])
if (~isempty(varargin))
    set(h, varargin{:});
end



% ylim(zlims)
