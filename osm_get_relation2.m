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
function [relation_lon, relation_lat, relation] = osm_get_relation2(relationID, varargin)

relationID = '4751577';
url0 = 'https://www.openstreetmap.org/api/0.6/relation/';


url = [url0 relationID '/full'];

data0 = webread(url);
elements = data0.elements;
j1 = 0;
j2 = 0;
j3 = 0;
for i = 1 : length(elements)
    element = elements{i};
    switch element.type
        case 'node'
            j1 = j1 + 1;
            node_id(j1) = string(element.id);
            node_lon(j1) = element.lon;
            node_lat(j1) = element.lat;
        case 'way'
            j2 = j2 + 1;
            way_id(j2) = string(element.id);
            nodes = string(element.nodes);
            clear nd
            for k = 1 : length(nodes)
                nd(k) = find(contains(node_id, nodes{k}));
            end
            way_nodes{j2} = nodes;
            way_lon{j2} = [node_lon(nd) nan];
            way_lat{j2} = [node_lat(nd) nan];
        case 'relation'
            j3 = j3 + 1;
            relation_id(j3) = string(element.id);
            ways = string([element.members.ref]);
            k2 = 0;
            clear wy 
            for k1 = 1: length(ways)
                if ~strcmp(element.members(k1).type, 'relation')
                    k2 = k2 + 1;
                    wy(k2) = find(contains(way_id, ways{k1}));
                end
            end
%             relation_ways = ways;
%             relation_role = string({element.members.role}); 
            relation_lon{j3} = [way_lon{wy(end:-1:1)} nan];
            relation_lat{j3} = [way_lat{wy(end:-1:1)} nan]; 
    end
end

% Output
if nargout > 2
    for i = 1 : length(relation_id)
        relation(i).id = relation_id(i);
        relation(i).lon = relation_lon{i};
        relation(i).lat = relation_lat{i};
    end
end

relation_lon = [relation_lon{:}];
relation_lat = [relation_lat{:}];


% txt = urlread(url);
% 
% % Read the node
% txt_id = extractBetween(txt, '<node id="', '"');
% txt_lon = extractBetween(txt, '" lon="', '"');
% txt_lat = extractBetween(txt, '" lat="', '"');
% m = length(txt_id);
% for i = 1 : m
%     node(i).id = convertCharsToStrings(txt_id{i});
%     node(i).lon = str2num(txt_lon{i});
%     node(i).lat = str2num(txt_lat{i});
% end
% node_id = [node(:).id];
% node_lon = [node(:).lon];
% node_lat = [node(:).lat];
% 
% 
% % Read the way
% txt_nd = extractBetween(txt, '<nd ref="', '"');
% n = length(txt_nd);
% for j = 1 : n
%     nd(j) = find(contains(node_id, txt_nd{j}));
% end
% way.nd = nd;
% way.lon = [node_lon(nd) nan];
% way.lat = [node_lat(nd) nan];
% 
