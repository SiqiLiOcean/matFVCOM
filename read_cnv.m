%==========================================================================
% Read the cnv file
%
% input  :
%   fcnv --- cnv file path and name
% 
% output :
%   lon  --- longitude
%   lat  --- latitude
%   depth --- depth
%   time  --- time in datenum format
%   T     --- tempearture
%   S     --- salinity
%
% Siqi Li, SMAST
% yyfyy-mm-dd
%
% Updates:
%
%==========================================================================
function [lon, lat, z, time, T, S] = read_cnv(fcnv)

% clc
% clear
% fcnv = '../input/lter/AR34A/ctd/dar34a001.cnv';

fid = fopen(fcnv);
lines = textscan(fid, '%s', 'delimiter', '\n');
lines = lines{1};
fclose(fid);


lon = read_loc(lines, '* NMEA Longitude');
lat = read_loc(lines, '* NMEA Latitude');
time = read_time(lines, '* NMEA UTC');

col_z = read_val_column(lines, 'prDM') + 1;
col_T = read_val_column(lines, 't090C') + 1;
col_S = read_val_column(lines, 'sal00') + 1;

z = read_data(lines, col_z);
T = read_data(lines, col_T);
S = read_data(lines, col_S);


%--------------------------------------------------------------------------
function value = read_loc(lines, str)

for i = 1 : length(lines)
    k = strfind(lines{i}, str);

    if k > 0    
        k = strfind(lines{i}, '=') + 1;
        val = lines{i}(k:end);
        break
    end
end

data = textscan(val, '%d%f%s');
    
value = double(data{1}) + data{2}/60;
if strcmp(data{3}, 'W') || strcmp(data{3}, 'S')
    value = -value;
end

end

%--------------------------------------------------------------------------
function value = read_time(lines, str)

for i = 1 : length(lines)
    k = strfind(lines{i}, str);

    if k > 0    
        k = strfind(lines{i}, '=') + 1;
        val = lines{i}(k:end);
        break
    end
end

value = datestr(val);

end

%--------------------------------------------------------------------------
function col = read_val_column(lines, str)

for i = 1 : length(lines)
    if startsWith(lines{i}, '# name ')
        if strfind(lines{i}, str)
            data = textscan(lines{i}, '%s %s %d');
            col = data{3};
            break
        end
    end
end

end

%--------------------------------------------------------------------------
function data = read_data(lines, col)

k = find(~startsWith(lines, {'#', '*'}));

value = [];
for i = 1 : length(k)
    val = textscan(lines{k(i)}, '%f');
    value = [value; val{1}'];
end

data = value(:, col);


end
