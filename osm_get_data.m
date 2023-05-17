%==========================================================================
% matFVCOM package
%   get OSM relation data
%
% input  :
%   relationID --- the ID of relation
% 
% output :
%   relation
%
% Siqi Li, SMAST
% 2023-05-07
%
% Updates:
%
%==========================================================================
function [outlon, outlat] = osm_get_data(IDs, varargin)


if ischar(IDs)
    IDs = convertCharsToStrings(IDs);
end

n = length(IDs);

outlon = [];
outlat = [];
for i = 1 : n
    type = IDs{i}(1);
    id = IDs{i}(2:end);
    switch upper(type)
        case 'N'
            [lon, lat] = osm_get_node(id);
            lon = [lon nan];
            lat = [lat nan];
        case 'W'
            [lon, lat] = osm_get_way(id);
        case 'R'
            [lon, lat] = osm_get_relation(id);
        case {'C', 'O'}    % Group of ways: C---closed; O---opened
            [id, direction] = split(id, {'+', '-'});
            id(1) = [];
            if length(id) ~= length(direction)
                error(['Wrong usage: ' IDs])
            end
            lon = [];
            lat = [];
            for j = 1 : length(id)
                [tmplon, tmplat] = osm_get_data(id{j});
                tmplon(end) = [];
                tmplat(end) = [];
                if strcmp(direction{j}, '-')
                    tmplon = fliplr(tmplon);
                    tmplat = fliplr(tmplat);
                end
                if j>1
                    if sqrt((lon(end)-tmplon(1))^2+(lat(end)-tmplat(1))^2)<1e-8
                        tmplon(1) = [];
                        tmplat(1) = [];
                    end
                end
                lon = [lon tmplon];
                lat = [lat tmplat];
            end
            lon = [lon nan];
            lat = [lat nan];
        otherwise
            error(['IDs should start with N, W, or R: ' num2str(i) '-' IDs{i}]);
    end
    outlon = [outlon lon];
    outlat = [outlat lat];
end







