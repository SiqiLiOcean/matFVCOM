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
% 2021-06-21
%==========================================================================

function [h, dd, zz, var_out] = w_transect_contour(wgrid, var, x0, y0, varargin)

varargin = read_varargin(varargin, ...
            {'FontSize', 'LabelSpacing', 'Color'}, ...
            {        12,            100,     'k'});

varargin = read_varargin(varargin, {'Levels'}, {[]});
varargin = read_varargin2(varargin, {'Geo'});

if length(size(var))~=3
    error('The dimension # of your VAR should be 3.')
end

varargin = read_varargin(varargin, ...
    {'npixel', 'zlims', 'VerticalType', 'it'}, ...
    {     200,      [],            'Z',    1});

varargin = read_varargin(varargin, {'Shift'}, {0});
varargin = read_varargin(varargin, {'Scale'}, {1});

[n1, n2, n3] = size(var);

x = wgrid.x;
y = wgrid.y;
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

% if strcmp(VerticalType, 'P')
%     z = flip(z, 2);
%     var = flip(var, 2);
% end

% Calculate the data for the transect figure
% [dd, zz, var_out] = interp_transect(x, y, z, var, x0, y0, 'zlims', zlims, 'npixel', 200);
[dd, zz, var_out] = interp_transect('QU', var, x, y, z, x0, y0, 'zlims', zlims, 'npixel', npixel, Geo);

dd = dd*Scale + Shift;

% Pcolor the transect
if isempty(Levels)
    [C, h] = contour(dd, zz, var_out);
else
    [C, h] = contour(dd, zz, var_out, Levels);
end

clabel(C, h, 'fontsize',FontSize, ...
             'LabelSpacing', LabelSpacing, ...
             'Color', Color);
         


set(h, 'linecolor', Color)
xlim([min(dd(:)) max(dd(:))])

if strcmp(VerticalType, 'P')
    set(gca,'Ydir','reverse')
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

if (~isempty(varargin))
    set(h, varargin{:});
end


% ylim(zlims)