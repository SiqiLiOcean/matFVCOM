%==========================================================================
% matFVCOM package
%   get OSM relation data
%
% input  :
%   relationID --- the ID of relation
% 
% output :
%   relation_lon
%   relation_lat
%   relation
%
% Siqi Li, SMAST
% 2023-05-07
%
% Updates:
%
%==========================================================================
function [relation_lon, relation_lat] = osm_get_relation(relationID, varargin)

% relationID = '4751577';
url0 = 'https://www.openstreetmap.org/api/0.6/relation/';


url = [url0 relationID];

data0 = webread(url);
members = data0.elements.members;

relation_lon = [];
relation_lat = [];
for i = 1 : length(members)
    id = num2str(members(i).ref);
    switch members(i).type
        case 'way'
            [lon, lat] = osm_get_way(id);
        case 'relation'
            [lon, lat] = osm_get_relation(id);
    end
    relation_lon = [relation_lon lon];
    relation_lat = [relation_lat lat];
end


