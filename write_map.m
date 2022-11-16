%==========================================================================
% Write SMS map file
%
% input  : 
% fmap
% map
%   --- head
%   --- NODE
%   --- ARC
%   --- tail
%
% output : 
% 
% Siqi Li, SMAST
% 2022-01-07
%
% Updates:
%
%==========================================================================
function write_map(fmap, map, varargin)

varargin = read_varargin(varargin, {'Format'}, {'%16.8f'});
varargin = read_varargin2(varargin, {'Clean'});

if Clean
    map = clean_map(map);
end

head = map.head;
NODE = map.NODE;
ARC = map.ARC;
tail = map.tail;

fid = fopen(fmap, 'w');

for i = 1 : length(head)
    fprintf(fid, '%s\n', head{i});
end

% NODE
% XY -70.734499 42.213592 0.0
% ID 1
% END
for i = 1 : length(NODE)
    fprintf(fid, '%s\n', 'NODE');
    fprintf(fid, ['%s ' Format ' ' Format ' '  Format '\n'], 'XY', NODE(i).x, NODE(i).y, NODE(i).h);
    fprintf(fid, '%s %d\n', 'ID', NODE(i).id);
    fprintf(fid, '%s\n', 'END');
end

% ARC
% ID 2
% ARCELEVATION 0.000000
% NODES      463      465
% ARCVERTICES 146750
% -70.716347999999996 42.171976999999998 0.000000000000000
% ...
% -70.699877000000001 42.152096000000000 0.000000000000000
% END
for i = 1 : length(ARC)
    fprintf(fid, '%s\n', 'ARC');
    for j = 1 : length(ARC(i).line)
        fprintf(fid, '%s\n', ARC(i).line{j});
    end
    for j = 2 : size((ARC(i).x), 1)-1   % Remove the first and last NODEs.
        fprintf(fid, [Format ' ' Format ' ' Format '\n'], ARC(i).x(j), ARC(i).y(j), ARC(i).h(j));
    end
%     fprintf(fid, '%s\n', 'ARC');
%     fprintf(fid, '%s %d\n', 'ID', ARC(i).id);
%     fprintf(fid, '%s %d\n', 'ARCELEVATION', ARC(i).elevation);
%     fprintf(fid, '%s %d %d\n', 'NODES', ARC(i).nodes);
%     fprintf(fid, '%s %d\n', 'ARCVERTICES', ARC(i).n);
%     for j = 1 : ARC(i).n
%         fprintf(fid, [Format ' ' Format ' ' Format '\n'], ARC(i).x(j), ARC(i).y(j), ARC(i).h(j));
%     end
    fprintf(fid, '%s\n', 'END');
end

for i = 1 : length(tail)
    fprintf(fid, '%s\n', tail{i});
end


fclose(fid);


end


function map2 = clean_map(map1)


arc_n = length(map1.ARC);

x1 = [map1.NODE.x]';
y1 = [map1.NODE.y]';
h1 = [map1.NODE.h]';
id1 = [map1.NODE.id]';
xy1 = [x1 y1];


[~, ia, ic] = unique(xy1, 'rows');

node_n2 = length(ia);


map2.head = map1.head;
map2.tail = map1.tail;
% NODE
for i = 1 : node_n2
    map2.NODE(i).x = x1(ia(i));
    map2.NODE(i).y = y1(ia(i));
    map2.NODE(i).h = h1(ia(i));
    map2.NODE(i).id = i;
end
% ARC
map2.ARC = map1.ARC;
for i = 1 : arc_n
    k1 = ic(map1.ARC(i).nodes(1)==id1);
    k2 = ic(map1.ARC(i).nodes(2)==id1);
    map2.ARC(i).nodes = [k1 k2];
    for j = 1 : length(map2.ARC(i).line)
        if startsWith(map2.ARC(i).line{j}, 'NODES')
            map2.ARC(i).line{j} = sprintf('%s%9d%9d', 'NODES', k1, k2);
            break
        end
    end
end

end