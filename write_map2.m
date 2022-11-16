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
function write_map2(fmap, map, varargin)

varargin = read_varargin(varargin, {'Format'}, {'%16.8f'});

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
    fprintf(fid, '%s %d\n', 'ID', ARC(i).id);
    fprintf(fid, '%s %d\n', 'ARCELEVATION', ARC(i).elevation);
    fprintf(fid, '%s %d %d\n', 'NODES', ARC(i).nodes);
    fprintf(fid, '%s %d\n', 'ARCVERTICES', ARC(i).n);
    for j = 1 : ARC(i).n
        fprintf(fid, [Format ' ' Format ' ' Format '\n'], ARC(i).x(j), ARC(i).y(j), ARC(i).h(j));
    end
    fprintf(fid, '%s\n', 'END');
end

for i = 1 : length(tail)
    fprintf(fid, '%s\n', tail{i});
end


fclose(fid);


        