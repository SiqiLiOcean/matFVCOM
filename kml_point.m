%==========================================================================
% Draw points in Google Earth
%
% input  :
% lon         --- Longitude
% lat         --- Latitude
% 'Model'     --- Model name
% 'Name'      --- Cell of point names
% 'alt'       --- Altitude in meter
% 'iconURL'   --- Marker style, choose one from http://jyotirmaya.blogspot.com/2008/03/google-map-files-kml-icon.html
% 'iconColor' --- Marker color
% output :
%
% Siqi Li, SMAST
% 2021-11-15
%
% Updates:
%
%==========================================================================
function k = kml_point(fout, lon, lat, varargin)


varargin = read_varargin(varargin, {'Model'}, {'Point'});
n = length(lon);
varargin = read_varargin(varargin, {'Name'}, {cellstr(num2str([1:n]'))});
varargin = read_varargin(varargin, {'alt'}, {zeros(n,1)});
varargin = read_varargin(varargin, {'iconURL'}, {'http://maps.google.com/mapfiles/kml/pal4/icon57.png'});
varargin = read_varargin(varargin, {'iconColor'}, {[255 255 0]});
varargin = read_varargin(varargin, {'iconScale'}, {2});


switch class(iconColor)
case 'char'
    RGB = COLOR2RGB(iconColor);
    iconColor = RGB2ABGR(255, RGB);
case 'double'
    iconColor = RGB2ABGR(255, iconColor);
otherwise
    error('Unknown iconColor')
end


k = kml(Model);
for i = 1 : n
    k.point(lon(i), lat(i), alt(i), ...
            'name', Name{i}, ...
            'iconURL', iconURL, ...
            'iconColor', iconColor);
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