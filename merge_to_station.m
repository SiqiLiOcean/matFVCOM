%==========================================================================
% 
%
% input  :
%   record    ---         1         2      3     4     5     6  ...
%                 longitude  latitude  depth  time  var1  var2  ...
%   'Polygon' ---
%   'Clean'   --- remove the record with no observation
% 
% output :
%
% Siqi Li, SMAST
% 2021-09-28
%
% Updates:
%
%==========================================================================
function sta = merge_to_station(record, varargin)

varargin = read_varargin(varargin, {'Polygon'}, {[]});
varargin = read_varargin2(varargin, {'Clean'});

if Clean
    data = record(:, 5:end);
    k = all(isnan(data), 2);
    record(k, :) = [];
end

n_rec = size(record, 1);

if ~isempty(Polygon)
    k = find(inpolygon(record(:,1), record(:,2), Polygon(:,1), Polygon(:,2)));
else
    k = 1 : n_rec;
end

lonlat = unique(record(k,1:2), 'rows');

for i = 1 : size(lonlat, 1)
    
    lon = lonlat(i,1);
    lat = lonlat(i,2);
    k = find(record(:,1)==lon & record(:,2)==lat);
    rec = record(k, :);
    
    depth = unique(record(k, 3));
    nz = length(depth);
    time = unique(record(k, 4));
    nt = length(time);
    
    sta(i,1).lon = lon;
    sta(i,1).lat = lat;
    sta(i,1).depth = depth;
    sta(i,1).time = time;
    
    for iv = 1 : length(varargin)
        var = nan(nz, nt);
        for iz = 1 : nz
            for it = 1 : nt
                j = rec(:,3)==depth(iz) & rec(:,4)==time(it);
                var(iz, it) = rec(j,iv+4);
            end
        end
        cmd = ['sta(i,1).' varargin{iv} '=var;'];
        eval(cmd);
    end
    
    
    
end