%==========================================================================
% Plot basemap
%
% input  :
%   bm ---
%   Brightness --- optional, (default: 0)
% 
% output :
%   im --- handle for image
%
% Siqi Li, SMAST
% 2022-04-05
%
% Updates:
%
%==========================================================================
function im = basemap_plot(bm, varargin)

varargin = read_varargin(varargin, {'Brightness'}, {0});

% nx = size(A, 2);
% ny = size(A, 1);
% lon = linspace(lon_lims(1), lon_lims(2), nx);
% lat = linspace(lat_lims(1), lat_lims(2), ny);
% [lat, lon] = 

bm.A = bm.A + Brightness;

im = image(bm.x, bm.y, bm.A);
im.Parent.YDir = 'normal';

if ~isempty(varargin)
    set(im, varargin{:})
end