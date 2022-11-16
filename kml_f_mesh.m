%==========================================================================
% Draw FVCOM mesh in KML
%
% input  : fgrid --- FVCOM grid cell
%          fout  --- output path and name
%          'Model'     --- name displayed in Google Earth
%          'LineWidth' --- line width
%          'LineColor' --- line color ('r', 'red' or [255 0 0])
% 
% output : \
%
% Siqi Li, SMAST
% 2021-06-09
%
% Updates:
%
%==========================================================================
function k = kml_f_mesh(fgrid, fout, varargin)

% fgrid = f;
% Model = 'FVCOM Mesh';
% LineWidth = 1.5;
% LineColor = 'FFF1F258';

% Default settings:
varargin = read_varargin(varargin, {'Model'}, {'FVCOM Mesh'});
varargin = read_varargin(varargin, {'Altitude'}, {0});
if numel(Altitude) == 1
    Altitude = ones(fgrid.node) * Altitude;
end
varargin = read_varargin(varargin, {'LineWidth'}, {1.5});
% varargin = read_varargin(varargin, {'LineColor'}, {'FFF1F258'});
varargin = read_varargin(varargin, {'LineColor'}, {[88 242 241]});
switch class(LineColor)
case 'char'
    RGB = COLOR2RGB(LineColor);
    LineColor = RGB2ABGR(255, RGB);
case 'double'
    LineColor = RGB2ABGR(255, LineColor);
otherwise
    error('Unknown LineColor')
end

% % lineWidth = 1.5;
% % lineColor = 'FFF1F258';
% % 
% % if ~isempty(varargin)
% %     i = 1;
% %     while i < nargin-3
% %         switch lower(varargin{1})
% %             case 'linewidth'
% %                 lineWidth = varargin{i+1};
% %                 i = i + 2;
% %             case 'linecolor'
% %                 input = varargin{i+1};
% %                 i = i + 2;
% %                 
% %                 switch class(input)
% %                     case 'char'
% %                         RGB = COLOR2RGB(input);
% %                         lineColor = RGB2ABGR(255, RGB);
% %                     case 'double'
% %                         lineColor = RGB2ABGR(255, input*255);
% %                 end
% %   
% %             otherwise
% %                 error(['Unknown input: ' varargin{i}])
% %         end
% %     end
% % end


if ~isfield(fgrid, 'lines_x')
    [bdy_x, bdy_y, lines_x, lines_y] = f_calc_boundary(fgrid);
    fgrid.bdy_x = bdy_x;
    fgrid.bdy_y = bdy_y;
    fgrid.lines_x = lines_x;
    fgrid.lines_y = lines_y;
    assignin('base', inputname(1), fgrid);
end

n = size(fgrid.lines_x, 1);

k = kml(Model);

if n < 600000000
    
    x = fgrid.lines_x;
    y = fgrid.lines_y;
    x(:,3) = nan;
    y(:,3) = nan;
    x = reshape(x', 1, []);
    y = reshape(y', 1, []);
    
    slice = 60000;
    
    for i = 1 : ceil(length(x)/slice)
        i1 = (i-1)*slice + 1;
        i2 = min(i*slice, length(x));
        k.plot(x(i1:i2), y(i1:i2), ...
            'altitude', Altitude(i1:i2),              ...
            'altitudeMode', 'absolute', ...
            'lineWidth', LineWidth,     ...
            'lineColor', LineColor,     ...
            'name', 'FVCOM Mesh');
    end
%     for i = 1 : n
%         if mod(i, 1000) == 0; disp([num2str(i) ' / ' num2str(n)]);end
%         k.plot(fgrid.lines_x(i,:), fgrid.lines_y(i,:), ...
%             'altitude', 0,              ...
%             'altitudeMode', 'absolute', ...
%             'lineWidth', LineWidth,     ...
%             'lineColor', LineColor,     ...
%             'name', 'FVCOM Mesh');
%     end

else
    
    % This method takes too much time on calculating strings.
    string = f_calc_string(fgrid);
    n = length(string);
    for i = 1 : n
        if mod(i, 1000) == 0; disp([num2str(i) ' / ' num2str(n)]);end
        k.plot(fgrid.x(string{i}), fgrid.y(string{i}), ...
            'altitude', Altitude(string{i}),              ...
            'altitudeMode', 'absolute', ...
            'lineWidth', LineWidth,     ...
            'lineColor', LineColor,     ...
            'name', 'FVCOM Mesh');
    end

end

k.save(fout);

end


function ARGB = RGB2ABGR(alpha, RGB)

    if max(alpha) <= 1
        alpha = alpha * 255;
    end
    if max(RGB(:)) <= 1
        RGB = RGB * 255;
    end
    
    ARGB = [dec2hex(alpha,2) dec2hex(RGB(3),2) dec2hex(RGB(2),2) dec2hex(RGB(1),2)];
    
end

function RGB = COLOR2RGB(COLOR)
    
    switch COLOR
        case {'red', 'r'}
            RGB = [255 0 0];
        case {'green', 'g'}
            RGB = [0 255 0];
        case {'blue', 'b'}
            RGB = [0 0 255];
        case {'cyan', 'c'}
            RGB = [0 255 255];
        case {'magenta', 'm'}
            RGB = [255 0 255];
        case {'yellow', 'y'}
            RGB = [255 255 0];
        case {'black', 'k'}
            RGB = [0 0 0];
        case {'white', 'w'}
            RGB = [255 255 255];
        otherwise
            error(['Unknown color code: ' COLOR])
    end
    
end