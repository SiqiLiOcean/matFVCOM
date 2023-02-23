%==========================================================================
% Plot line with interpolated gradient colors
% 
%
% input  :
%   x --- coordinate x
%   y --- coordinate y
%   z --- data for color
%
% output :
%
% Siqi Li, SMAST
% 2023-02-17
%
% Updates:
%
%==========================================================================
function h = plot2(x, y, z, varargin)

varargin = read_varargin(varargin, {'ColarMap'}, {colormap});
varargin = read_varargin(varargin, {'Clims'}, {minmax(z)});

nColor = size(ColarMap, 1);
z_cm = linspace(Clims(1), Clims(2), nColor);
CD(1,:) = interp1(z_cm, ColarMap(:,1), z);
CD(2,:) = interp1(z_cm, ColarMap(:,2), z);
CD(3,:) = interp1(z_cm, ColarMap(:,3), z);
CD = uint8(CD * 255);
CD(4,:) = 1;



h = plot(x, y, '-');

if ~isempty(varargin)
    set(h, varargin{:})
end

drawnow
set(h.Edge, 'ColorBinding','interpolated', 'ColorData',CD)


