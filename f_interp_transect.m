function [var1, x_sec, y_sec, d_sec] = f_interp_transect(fgrid, var, x, y, varargin)

varargin = read_varargin(varargin, {'npixel'}, {200});
varargin = read_varargin2(varargin, {'Extrap'});
varargin = read_varargin(varargin, {'K'}, {7});

var = var(:);
switch length(var) 
    case fgrid.node
        
    case fgrid.nele
        var = f_interp_cell2node(fgrid, var);
    otherwise
        error('Wrong size of input var.')
end

[x_sec, y_sec, d_sec] = interp_transect_pixel_horizontal(x, y, 'npixel', npixel);

if Extrap
    var1 = interp_2d(var, 'TRI', fgrid.x, fgrid.y, fgrid.nv, x_sec, y_sec, 'Extrap', 'K', K);
else
    var1 = interp_2d(var, 'TRI', fgrid.x, fgrid.y, fgrid.nv, x_sec, y_sec, 'K', K);
end
