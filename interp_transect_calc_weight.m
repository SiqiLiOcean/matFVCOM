%==========================================================================
% Interpolation for transect plot
%
% Input  : x_in (n_in)
%          y_in (n_in)
%          z_in (n_in,nsigma_in)
%          var_in (n_in,nsigma_in)
%          x (n_out)
%          y (n_out)
%          z (2) [min(depth) max(depth)]
% Output : dd (n_out,nz_out)
%          zz (n_out,nz_out)
%          var_out(n_out,nz_out)
%
% Note : The depth1 and depth2 are all positive, and should be increasing.
%
% Siqi Li, SMAST
% 2020-03-17
%
% Updates:
%==========================================================================
function [dd, zz, weight, x_sec, y_sec] = interp_transect_calc_weight(METHOD_2D, varargin)

switch upper(METHOD_2D)
    case 'TRI'
        x1 = varargin{1};
        y1 = varargin{2};
        z1 = varargin{3};
        nv1 = varargin{4};
        x2 = varargin{5};
        y2 = varargin{6};
        varargin(1:6) = [];
    case {'BI', 'ID', 'QU'}
        x1 = varargin{1};
        y1 = varargin{2};
        z1 = varargin{3};
        x2 = varargin{4};
        y2 = varargin{5};
        varargin(1:5) = []; 
    otherwise
        error('Unknown METHOD_2D')
end

% varargin = read_varargin2(varargin, {'Extrap'});
% varargin = read_varargin(varargin, {'K'}, {7});
% varargin = read_varargin(varargin, {'np', 'Power'}, {6, 2});

varargin = read_varargin(varargin, {'zlims', 'npixel'}, {[], 200});
varargin = read_varargin2(varargin, {'Geo'});



% dims1=size(x1);

% [x_sec, y_sec, d_sec, z_sec] = interp_transect_pixel(x2, y2, zlims, 'npixel', npixel);
% if Geo
%     [x_sec, y_sec, d_sec] = interp_transect_pixel_horizontal(x2, y2, 'npixel', npixel, 'Geo');
% else
%     [x_sec, y_sec, d_sec] = interp_transect_pixel_horizontal(x2, y2, 'npixel', npixel);
% end
[x_sec, y_sec, d_sec] = interp_transect_pixel_horizontal(x2, y2, 'npixel', npixel, Geo);

% weight.h = interp_horizontal_calc_weight(x1, y1, x_sec, y_sec);
switch METHOD_2D
    case 'TRI'
        weight.h = interp_2d_calc_weight(METHOD_2D, x1, y1, nv1, x_sec, y_sec, varargin{:});
    case {'BI', 'ID', 'QU'}
        weight.h = interp_2d_calc_weight(METHOD_2D, x1, y1, x_sec, y_sec, varargin{:});
end

if isempty(zlims)
    z_bot = interp_2d_via_weight(min(z1, [], length(size(z1))), weight.h);
    z_top = interp_2d_via_weight(max(z1, [], length(size(z1))), weight.h);
    
    zlims = [min(z_bot(:)) max(z_top(:))];
end



z_sec = interp_transect_pixel_vertical(zlims, 'npixel', npixel);

% z2 = repmat(z_sec,n1,1);

% permute(z_sec(:)',[1 3 2])
z1 = reshape(z1, numel(x1), []);
z2 = repmat(z_sec, numel(x1), 1);
weight.v = interp_vertical_calc_weight(z1, z2, 'list',unique(weight.h.id));

% ====================Generate the transect grid====================
% [dd,hh]=meshgrid(d_sec,-h_sec);
[zz,dd]=meshgrid(z_sec,d_sec);

