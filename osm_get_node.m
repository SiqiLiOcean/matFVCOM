%==========================================================================
% matFVCOM package
%   get OSM node data
%
% input  :
%   nodeID --- the ID of node
% 
% output :
%   node_lon
%   node_lat
%   node
%
% Siqi Li, SMAST
% 2023-05-07
%
% Updates:
%
%==========================================================================
function [node_lon, node_lat, node] = osm_get_node(nodeID, varargin)



url0 = 'https://www.openstreetmap.org/api/0.6/node/';


url = [url0 nodeID];

txt = urlread(url);

% Read the node
txt_id = extractBetween(txt, '<node id="', '"');
txt_lon = extractBetween(txt, '" lon="', '"');
txt_lat = extractBetween(txt, '" lat="', '"');

% Output
node_lon = str2num(txt_lon);
node_lat = str2num(txt_lat);

if nargout > 2
    node.id = convertCharsToStrings(txt_id);
    node.lon = node_lon;
    node.lat = node_lat;
end

