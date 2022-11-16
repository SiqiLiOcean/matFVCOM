
function [h, dd, zz, var_out] = w_transect_image(wgrid, var, x0, y0, varargin)


if length(size(var))~=3
    error('The dimension # of your VAR should be 3.')
end

varargin = read_varargin(varargin, ...
    {'npixel', 'zlims', 'VerticalType', 'it'}, ...
    {     200,      [],            'Z',    1});

varargin = read_varargin(varargin, {'Levels'}, {[]});
varargin = read_varargin2(varargin, {'Extrap'});
varargin = read_varargin2(varargin, {'Geo'});
varargin = read_varargin(varargin, {'Shift'}, {0});
varargin = read_varargin(varargin, {'Scale'}, {1});



[n1, n2, n3] = size(var);

x = wgrid.x;
y = wgrid.y;
% h = wgrid.hgt(:,:,it);

switch upper(VerticalType)
    case 'Z'
        z = wgrid.z(:,:,:,it);
    case 'P'
        z = wgrid.p(:,:,:,it);
    otherwise
        error('Unknown VERTICAL_TYPE')
end
nx = wgrid.nx;
ny = wgrid.ny;
nz = wgrid.nz;


% x = x(:);
% y = y(:);
% z = reshape(z, nx*ny, nz);
% var = reshape(var, nx*ny, nz);


if n1==nx && n2==ny && n3==nz 

elseif n1==nx+1 && n2==ny && n3==nz 
    var = w_interp_UV2M(wgrid, var);
elseif n1==nx && n2==ny+1 && n3==nz 
    var = w_interp_UV2M(wgrid, var);
elseif n1==nx && n2==ny && n3==nz+1
    var = w_interp_W2M(wgrid, var);
else
    error('The dimensions do not match the grid')
end




% [x_sec, y_sec, d_sec] = interp_transect_pixel_horizontal(x0, y0, 'npixel', npixel);
% h_topo = interp_horizontal(x, y, h, x_sec, y_sec)

% if strcmp(VerticalType, 'P')
%     z = flip(z, 2);
%     var = flip(var, 2);
% end

% Calculate the data for the transect figure
% if Extrap
%     [dd, zz, var_out] = interp_transect('QU', var, x, y, z, x0, y0, 'zlims', zlims, 'npixel', npixel, 'Extrap');
% else
%     [dd, zz, var_out] = interp_transect('QU', var, x, y, z, x0, y0, 'zlims', zlims, 'npixel', npixel);
% end
[dd, zz, var_out] = interp_transect('QU', var, x, y, z, x0, y0, 'zlims', zlims, 'npixel', npixel, Extrap, Geo);

dd = dd*Scale + Shift;

% % Pcolor the transect
% h = pcolor(dd, zz, var_out);
% set(h, 'linestyle', 'none')
% Contourf the transect
if isempty(Levels)
    h = contourf(dd, zz, var_out, 'linestyle', 'none');
else
    h = contourf(dd, zz, var_out, Levels, 'linestyle', 'none');
end

if strcmp(VerticalType, 'P')
    set(gca,'Ydir','reverse')
end


if (~isempty(varargin))
    set(h, varargin{:});
end

xlim([min(dd(:)) max(dd(:))])
% ylim(zlims)