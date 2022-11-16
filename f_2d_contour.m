%==========================================================================
% Draw 2d contour for fvcom-grid variables
%
% input  : x   (x coordinate)
%          y   (y coordinate)
%          (The variables above will be got from fgrid)
%          var  (the drawn variable)  --- (node, 1), draw variable on node
%          varargin (the rest settings for the contour)
% output : h (figure handle)
%
% Usage: [C,h]= f_2d_contour(f, dd, 'LevelList', 5000);
%    
%
% Siqi Li, SMAST
% 2020-07-16
%==========================================================================
function [C, h, t] = f_2d_contour(fgrid, var, varargin)

varargin = read_varargin(varargin, ...
            {'FontSize', 'LabelSpacing', 'Color'}, ...
            {        12,            200,     'k'});
varargin = read_varargin(varargin, {'Levels'}, {[]});

varargin = read_varargin(varargin, {'xlims'}, {[]});
varargin = read_varargin(varargin, {'ylims'}, {[]});
        

varargin = read_varargin2(varargin, {'Manual'});     
varargin = read_varargin2(varargin, {'NoLabel'});
varargin = read_varargin2(varargin, {'Global'});


node = fgrid.node;
nele = fgrid.nele;

switch length(var)
    case node
        x = fgrid.x;
        y = fgrid.y;
    case nele
        x = fgrid.xc;
        y = fgrid.yc;
    otherwise
        error('Wrong size of input variable.')
end


x = double(x);
y = double(y);
var = double(var);

if isempty(xlims)
    xlims = [min(x) max(x)];
end
if isempty(ylims)
    ylims = [min(y) max(y)];
end

xl = linspace(xlims(1), xlims(2), 200);
yl = linspace(ylims(1), ylims(2), 200);


[yy, xx] = meshgrid(yl, xl);
zz = griddata(x, y, var, xx, yy);


if isempty(Levels)
    [C, h] = contour(xx, yy, zz);
else
    [C, h] = contour(xx, yy, zz, Levels);
end


set(h, 'linecolor', Color)


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
%             clabel(C, h, 'labelspacing', varargin{i+1});
%             varargin(i:i+1) = [];
%             i = i - 2;
%         case 'color'
%             c = varargin{i+1};
%             switch class(varargin{i+1})
%                 case 'char'
%                     if strcmp(varargin{i+1}, 'w') || strcmp(varargin{i+1}, 'white')
%                         c = [254 254 254]/255;
%                     end
%                 case 'double'
%                     if varargin{i} == [1 1 1]
%                         c = [254 254 254]/255;
%                     end
%             end
%             set(h, 'linecolor', c)
%             clabel(C, h, 'color', c);
%             varargin(i:i+1) = [];
%             i = i - 2;
%             
%     end
%             
%     i = i + 2;
% end





% if length(size(x))~=2      
%     error('Check the size of input data')
% end
%     
% [n1, n2] = size(x);
%     
% if n1>1 && n2>1    % the input data is in 2d mesh, no need to interpolation
%     
%     [C,h] = contour(x, y, var);
%     
% elseif n1==1 || n2==1    % the input data is array, we need to do the interpolation
%     
%     x = double(x);
%     y = double(y);
%     var = double(var);
%     
%     xlim = [min(x) max(x)];
%     ylim = [min(y) max(y)];
%     
%     xl = linspace(xlim(1), xlim(2),200);
%     yl = linspace(ylim(1), ylim(2),200);
%     
%     
%     [yy, xx] = meshgrid(yl, xl);
%     zz = griddata(x, y, var, xx, yy);
%     
%     
%     [C, h] = contour(xx, yy, zz);
%     
%     
% end
% 
% 
% set(h, 'linecolor', 'k')
% clabel(C,h,'fontsize',13);
% i = 1;
% while i<=length(varargin)
%     if strcmp(varargin{i}, 'fontsize')
%         clabel(C, h, 'fontsize', varargin{i+1});
%         varargin(i:i+1) = [];
%         break
%     end
%     i = i + 2;
% end
% 
% if (~isempty(varargin))
%     set(h, varargin{:});
% end

end

