%==========================================================================
% Read the kml/kmz file to get the Points, Lines, and Polygons.
%
% input  :
%   fin --- input kml/kmz file
%   Directory --- (optional) directory to save temperate kml file.
% 
% output :
%   point
%   line
%   polygon
%
% Siqi Li, SMAST
% 2022-09-04
%
% Updates:
%
%==========================================================================
function [point, line, polygon] = read_kml(fin, varargin)


varargin = read_varargin(varargin, {'Directory'}, {['./tmp_' datestr(now, 'yyyymmdd_HHMMSS')]});
varargin = read_varargin2(varargin, {'Delimiter'});

if endsWith(fin, '.kmz')
    unzip(fin, Directory);
    file = dir([Directory '/*kml']);
    fkml = [file.folder '/' file.name];
else
    fkml = fin;
end

text = fileread(fkml);
if endsWith(fin, '.kmz')
    rmdir(Directory, 's');
end

text_Placemark = extractBetween(text, '<Placemark', '</Placemark');

i = contains(text_Placemark, '<Point');
j = contains(text_Placemark, '<LineString');
k = contains(text_Placemark, '<Polygon');

if any(i)
    text_point = extractBetween(text_Placemark(i), '<Point', '</Point');
else
    text_point = {''};
end
if any(j)
    text_line = extractBetween(text_Placemark(j), '<LineString', '</LineString');
else
    text_line = {''};
end
if any(k)
    text_polygon = extractBetween(text_Placemark(k), '<Polygon', '</Polygon');
else
    text_polygon = {''};
end
coordinate_point = extractBetween(text_point, '<coordinates>', '</coordinates>');
coordinate_line = extractBetween(text_line, '<coordinates>', '</coordinates>');
coordinate_polygon = extractBetween(text_polygon, '<coordinates>', '</coordinates>');

point = [];
for i = 1 : length(coordinate_point)
    data = reshape(str2num(coordinate_point{i}), 3, [])';
    point(i,1).x = data(:,1)';
    point(i,1).y = data(:,2)';
    point(i,1).z = data(:,3)';
end

line = [];
for j = 1 : length(coordinate_line)
    data = reshape(str2num(coordinate_line{j}), 3, [])';
    if Delimiter
        line(j,1).x = [data(:,1)' nan];
        line(j,1).y = [data(:,2)' nan];
        line(j,1).z = [data(:,3)' nan];
    else
        line(j,1).x = data(:,1)';
        line(j,1).y = data(:,2)';
        line(j,1).z = data(:,3)';
    end
end

polygon = [];
for k = 1 : length(coordinate_polygon)
    data = reshape(str2num(coordinate_line{k}), 3, [])';
    if Delimiter
        polygon(k,1).x = [data(:,1)' nan];
        polygon(k,1).y = [data(:,2)' nan];
        polygon(k,1).z = [data(:,3)' nan];
    else
        polygon(k,1).x = data(:,1)';
        polygon(k,1).y = data(:,2)';
        polygon(k,1).z = data(:,3)';
    end
end




