%==========================================================================
% Draw 2D image for WRF variable
% 
% Input  : --- wgrid, WRF grid cell
%          --- var, 2d variable
%          --- varargin, settings for image figure
%
% Output : --- h, figure handle
% 
% Usage  : h = w_2d_image(wgrid, sst);
%
% v1.0
%
% Siqi Li
% 2021-05-11
%
% Updates:
% 2022-03-02  Siqi Li  Added the global option in BI method
%==========================================================================
function h = w_2d_image(wgrid, var, varargin)

varargin = read_varargin2(varargin, {'Global'});


x = wgrid.x;
y = wgrid.y;
nv = wgrid.nv;
nx = wgrid.nx;
ny = wgrid.ny;

var = double(var);

if Global
    edge_cell = find(max(x(nv), [], 2) - min(x(nv), [], 2)>181);
    nv(edge_cell, :) = [];
end

dims = size(var);
if dims(1) == nx && dims(2) == ny
    % variable on M grid
elseif dims(1) == nx+1 && dims(2) == ny
    % variable on U grid
    var = w_interp_UV2M(wgrid, var);
elseif dims(1) == nx && dims(2) == ny+1
    % variable on U grid
    var = w_interp_UV2M(wgrid, var);
else
    error('The input var size is wrong')
end

h = patch('Vertices',[x(:),y(:)], 'Faces',nv, 'FaceColor','interp', 'FaceVertexCData',var(:), 'EdgeColor','none');
   
% h = pcolor(lon, lat, var);
% set(h, 'linestyle', 'none')


if ~isempty(varargin)
    set(h, varargin{:})
end
