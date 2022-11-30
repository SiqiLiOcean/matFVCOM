
function [h, dd, zz, var_out] = f_transect_image(fgrid, var, x0, y0, varargin)


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


varargin = read_varargin(varargin, {'npixel', 'zlims'}, {200, []});
varargin = read_varargin2(varargin, {'Extrap'});
varargin = read_varargin(varargin, {'Levels'}, {[]});
varargin = read_varargin2(varargin, {'Geo'});
% [x_sec, y_sec, d_sec] = interp_transect_pixel_horizontal(x0, y0, 'npixel', npixel);
% h_topo = interp_horizontal(x, y, h, x_sec, y_sec)

% Calculate the data for the transect figure
% % if Extrap & Geo
% %     [dd, zz, var_out] = interp_transect('TRI', var, x, y, z, nv, x0, y0, 'zlims', zlims, 'npixel', npixel, 'Extrap', 'Geo');
% % elseif Extrap & ~Geo
% %     [dd, zz, var_out] = interp_transect('TRI', var, x, y, z, nv, x0, y0, 'zlims', zlims, 'npixel', npixel, 'Extrap');
% % elseif ~Extrap & Geo
% %     [dd, zz, var_out] = interp_transect('TRI', var, x, y, z, nv, x0, y0, 'zlims', zlims, 'npixel', npixel, 'Geo');
% % else
% %     [dd, zz, var_out] = interp_transect('TRI', var, x, y, z, nv, x0, y0, 'zlims', zlims, 'npixel', npixel);
% % end
[dd, zz, var_out] = interp_transect('TRI', var, x, y, z, nv, x0, y0, 'zlims', zlims, 'npixel', npixel, Extrap, Geo);

% % Pcolor the transect
% h = pcolor(dd, zz, var_out);
% set(h, 'linestyle', 'none')
% Contourf the transect
if isempty(Levels)
    [~,h] = contourf(dd, zz, var_out, 'linestyle', 'none');
else
    [~,h] = contourf(dd, zz, var_out, Levels, 'linestyle', 'none');
end

if (~isempty(varargin))
    set(h, varargin{:});
end

xlim([min(dd(:)) max(dd(:))])
% ylim(zlims)
