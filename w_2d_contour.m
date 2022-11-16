%==========================================================================
% Draw 2D contour for WRF variable
% 
% Input  : --- wgrid, WRF grid cell
%          --- var, 2d variable
%          --- varargin, settings for contour figure
%
% Output : --- h, figure handle
% 
% Usage  : h = w_2d_contour(wgrid, sst);
%
% v1.0
%
% Siqi Li
% 2021-05-11
%
% Updates:
%
%==========================================================================
function [C, h] = w_2d_contour(wgrid, var, varargin)


varargin = read_varargin(varargin, ...
            {'FontSize', 'LabelSpacing', 'Color'}, ...
            {        12,            100,     'k'});

varargin = read_varargin(varargin, {'Levels'}, {[]});

varargin = read_varargin2(varargin, {'Manual'});     
varargin = read_varargin2(varargin, {'NoLabel'});
% varargin = read_varargin2(varargin, {'Global'});

x = wgrid.x;
y = wgrid.y;
nx = wgrid.nx;
ny = wgrid.ny;

var = double(var);


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

if isempty(Levels)
    [C, h] = contour(x, y, var);
else
    [C, h] = contour(x, y, var, Levels);
end



set(h, 'linecolor', Color)

% clabel(C, h, 'fontsize',FontSize, ...
%              'LabelSpacing', LabelSpacing, ...
%              'Color', Color);
     
if isempty(NoLabel)
    
    if Manual
        clabel(C, h, 'manual', ...
            'fontsize',FontSize, ...
            'Color', Color);
    else
        clabel(C, h, 'fontsize',FontSize, ...
            'LabelSpacing', LabelSpacing, ...
            'Color', Color);
    end
end

% i = 1;
% while i<=length(varargin)
%     switch lower(varargin{i})
%         case 'fontsize'
%             clabel(C, h, 'fontsize', varargin{i+1});
%             varargin(i:i+1) = [];
%             i = i - 2;
%         case 'labelspacing'
%             clabel(C, h, 'labelspacing', varargin{i+1});
%             varargin(i:i+1) = [];
%             i = i - 2;            
%     end
%             
%     i = i + 2;
% end

if ~isempty(varargin)
    set(h, varargin{:})
end
