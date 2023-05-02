%==========================================================================
% Draw lines in Google Earth
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
function k = kml_poly(lon, lat, fout, varargin)


lon = lon(:);
lat = lat(:);

if ~isnan(lon(end))
    lon(end+1) = nan;
    lat(end+1) = nan;
end

varargin = read_varargin(varargin, {'Model'}, {'Line'});
n = sum(isnan(lon));
varargin = read_varargin(varargin, {'Name'}, {cellstr(num2str([1:n]'))});
varargin = read_varargin(varargin, {'alt'}, {ones(n,1)});
% varargin = read_varargin(varargin, {'iconURL'}, {'http://maps.google.com/mapfiles/kml/pal4/icon57.png'});
varargin = read_varargin(varargin, {'LineColor'}, {[255 255 0]});
varargin = read_varargin(varargin, {'LineWidth'}, {2.2});

if numel(alt) == 1
    alt = ones(n,1)*alt;
end

switch class(LineColor)
case 'char'
    RGB = COLOR2RGB(LineColor);
    LineColor = RGB2ABGR(255, RGB);
case 'double'
    LineColor = RGB2ABGR(255, LineColor);
otherwise
    error('Unknown iconColor')
end


m = find(isnan(lon));
m1 = [1; m(1:end-1)+1];
m2 = m - 1;

slice = 6000000;

k = kml(Model);
for i = 1 : n
    lon_tmp = lon(m1(i):m2(i));
    lat_tmp = lat(m1(i):m2(i));
    for j = 1 : ceil((m2(i)-m1(i)+1)/slice)
        i1 = (j-1)*slice + 1;
        i2 = min(j*slice, m2(i)-m1(i)+1);
        k.poly(lon_tmp(i1:i2), lat_tmp(i1:i2), ...
                'altitude', alt(i), ...
                'altitudeMode', 'relativeToGround', ...
                'name', Name{i});
%                 'lineWidth', LineWidth,     ...
%                 'lineColor', LineColor,     ...

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