%==========================================================================
% Read SMS map file
%
% input  : fmap
% 
% output : map
%            --- head
%            --- NODE
%            --- ARC
%            --- tail
%
% Siqi Li, SMAST
% 2022-01-07
%
% Updates:
%
%==========================================================================
function map = read_map2(fmap)

% clc
% clear
% 
% fmap = 'S_ll.map';

fid = fopen(fmap);

i = 0;
j = 0;
k1 = 0;
k2 = 0;
flag = 0;
while ~feof(fid)
    
    line = fgetl(fid);
    
    
    switch strtrim(line)
        case 'NODE'
            
            % NODE
            % XY -70.754825 42.171889 0.0
            % ID 388
            % END
            
            line1 = textscan(fid, '%s%f%f%f', 1);
            line2 = textscan(fid, '%s%d', 1);
            fgetl(fid);
            fgetl(fid);
            
            i = i + 1;
            NODE(i).x = line1{2};
            NODE(i).y = line1{3};
            NODE(i).h = line1{4};
            NODE(i).id = line2{2};
            
            flag = 1;
            
            continue
            
        case 'ARC'
    
            % ARC
            % ID 2
            % ARCELEVATION 0.000000
            % NODES      463      465
            % ARCVERTICES 146750
            % -70.716347999999996 42.171976999999998 0.000000000000000
            % ...
            % -70.699877000000001 42.152096000000000 0.000000000000000
            % END
            
            line1 = textscan(fid, '%s%d', 1);       % ID
            line2 = textscan(fid, '%s%f', 1);       % ARCELEVATION               
            line3 = textscan(fid, '%s%d%d', 1);     % NODE
            line4 = textscan(fid, '%s%d', 1);       % ARCVECTICES
            j = j + 1;
            ARC(j).id = line1{2};
            ARC(j).elevation = line2{2};
            ARC(j).nodes = [line3{2} line3{3}];
            ARC(j).n = line4{2};
            data = textscan(fid, '%f%f%f', ARC(j).n);
           	ARC(j).x = [data{1}(:)' nan];
            ARC(j).y = [data{2}(:)' nan];
            ARC(j).h = data{3};
            fgetl(fid);
            fgetl(fid);
            
            continue
            
    end
    
    if flag==0
        k1 = k1 + 1;
        head{k1,1} = line;
    else
        k2 = k2 + 1;
        tail{k2,1} = line;
    end

end

fclose(fid);

map.head = head;
map.tail = tail;
map.NODE = NODE;
map.ARC = ARC;

        