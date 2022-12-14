%==========================================================================
% Draw FVCOM boundary in KML
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
function k = f_kml_boundary(fgrid, fout, varargin)

% Default settings:
varargin = read_varargin(varargin, {'Model'}, {'FVCOM Boundary'});
varargin = read_varargin(varargin, {'LineWidth'}, {2.2});
% varargin = read_varargin(varargin, {'LineColor'}, {'FFFFFFFF'});
varargin = read_varargin(varargin, {'LineColor'}, {[255 255 255]});
switch class(LineColor)
case 'char'
    RGB = COLOR2RGB(LineColor);
    LineColor = RGB2ABGR(255, RGB);
case 'double'
    LineColor = RGB2ABGR(255, LineColor);
otherwise
    error('Unknown LineColor')
end

% % lineWidth = 2.2;
% % lineColor = 'FFFFFFFF';
% % 
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


if ~isfield(fgrid, 'bdy_x')
    [bdy_x, bdy_y, lines_x, lines_y] = f_calc_boundary(fgrid);
    fgrid.bdy_x = bdy_x;
    fgrid.bdy_y = bdy_y;
    fgrid.lines_x = lines_x;
    fgrid.lines_y = lines_y;
    assignin('base', inputname(1), fgrid);
end

x = [fgrid.bdy_x{:}];
y = [fgrid.bdy_y{:}];

k = kml(Model);
k.plot(x, y,   ...
           'altitude', 0,              ...
           'altitudeMode', 'absolute', ...
            'lineWidth', LineWidth,     ...
            'lineColor', LineColor,     ...
            'name', 'FVCOM boundary');
k.save(fout);


end


function ABGR = RGB2ABGR(alpha, RGB)
% RGB   : 1 ~ 255
% alpha : 1 ~ 255
    ABGR = [dec2hex(alpha,2) dec2hex(RGB(3),2) dec2hex(RGB(2),2) dec2hex(RGB(1),2)];
    
end
function RGB = COLOR2RGB(COLOR)
% COLOR : char
% RGB   : 1 ~ 255

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