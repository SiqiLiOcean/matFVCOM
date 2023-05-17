%==========================================================================
% matFVCOM package
%   get OSM way data
%
% input  :
%   wayID --- the ID of way
% 
% output :
%   way_lon
%   way_lat
%   way
%
% Siqi Li, SMAST
% 2023-05-07
%
% Updates:
%
%==========================================================================
function [way_lon, way_lat, way] = osm_get_way(wayID, varargin)



url0 = 'https://www.openstreetmap.org/api/0.6/way/';


url = [url0 wayID '/full'];

txt = urlread(url);

% Read the node
txt_id = extractBetween(txt, '<node id="', '"');
txt_lon = extractBetween(txt, '" lon="', '"');
txt_lat = extractBetween(txt, '" lat="', '"');
m = length(txt_id);
for i = 1 : m
    node(i).id = convertCharsToStrings(txt_id{i});
    node(i).lon = str2num(txt_lon{i});
    node(i).lat = str2num(txt_lat{i});
end
node_id = [node(:).id];
node_lon = [node(:).lon];
node_lat = [node(:).lat];


% Read the way
txt_id = extractBetween(txt, '<way id="', '"');
txt_nd = extractBetween(txt, '<nd ref="', '"');
n = length(txt_nd);
for j = 1 : n
    nd(j) = find(contains(node_id, txt_nd{j}));
end

% Output
way_lon = [node_lon(nd) nan];
way_lat = [node_lat(nd) nan];
if nargout > 2
    way.id = convertCharsToStrings(txt_id{1});
    way.nd = nd;
    way.lon = way_lon;
    way.lat = way_lat;
end
