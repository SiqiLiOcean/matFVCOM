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
varargin = read_varargin(varargin, {'PolyColor'}, {[255 255 0]});


if numel(alt) == 1
    alt = ones(n,1)*alt;
end

LineColor = color2rgb(LineColor);
PolyColor = color2rgb(PolyColor);


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
                'name', Name{i},     ...
                'lineWidth', LineWidth,     ...
                'lineColor', LineColor,     ...
                'polyColor', PolyColor);

    end
end
k.save(fout);

end

