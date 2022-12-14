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
function map = read_map(fmap)

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
            % DISTNODE 1                % may be absent
            % NODETYPE 0                % may be absent
            % ARCBIAS 1.000000          % may be absent
            % MERGED 0 0 0 0            % may be absent
            % NODES      463      465
            % ARCVERTICES 146750
            % -70.716347999999996 42.171976999999998 0.000000000000000
            % ...
            % -70.699877000000001 42.152096000000000 0.000000000000000
            % END
            
            j = j + 1;                  % ARC index
            k = 0;                      % line index
            while 1
                line = fgetl(fid);
                
                % Stop at the END
                if strcmp(line, 'END')
                    break
                end
                
%                 if startsWith(line, 'ARCVERTICES')
%                     n = read_line(line);
%                     data = textscan(fid, '%f%f%f', n);
%                     fgetl(fid);
%                     data = cell2mat(data);
% %                     ARC(j).x = data{1};
% %                     ARC(j).y = data{2};
% %                     ARC(j).h = data{3};
%                 end
                
                k = k + 1;              % line index

                ARC(j,1).line{k,1} = line;
                if startsWith(line, 'ID')
                    ARC(j,1).id = read_line(line);
                elseif startsWith(line, 'ELEVATION')
                    ARC(j,1).elevation = read_line(line);
                elseif startsWith(line, 'ARCVERTICES')
%                     ARC(j,1).n = read_line(line);
                    n = read_line(line);
                    data = textscan(fid, '%f%f%f', n);
                    fgetl(fid);
                    data = cell2mat(data);
                    ARC(j,1).x = [NODE(n1).x data(:,1)' NODE(n2).x];
                    ARC(j,1).y = [NODE(n1).y data(:,2)' NODE(n2).y];
                    ARC(j,1).h = [NODE(n1).h data(:,3)' NODE(n2).h];
                elseif startsWith(line, 'NODES')
                    ARC(j,1).nodes = read_line(line);
                    n1 = find([NODE.id]==ARC(j,1).nodes(1));
                    n2 = find([NODE.id]==ARC(j,1).nodes(2));
                end
                
            end

            % Add NaN at the end
            ARC(j,1).x(end+1) = nan;
            ARC(j,1).y(end+1) = nan;
            ARC(j,1).h(end+1) = nan;
            
            
%             ARC(j,1).x = [NODE(n1).x; data(:,1); NODE(n2).x];
%             ARC(j,1).y = [NODE(n1).y; data(:,2); NODE(n2).y];
%             ARC(j,1).h = [NODE(n1).h; data(:,3); NODE(n2).h];
            
            
            
            
            
%             line1 = textscan(fid, '%s%d', 1);       % ID
%             line2 = textscan(fid, '%s%f', 1);       % ARCELEVATION
%             pos = ftell(fid);
%             line = fgetl(fid);
%             fseek(fid, pos, 'bof');
%             if strcmp(line{1}, 'DISTNODE')
%                 line5 = textcan(fid, '%s%d', 1);
%                 line6 = textcan(fid, '%s%d', 1);
%                 line7 = textcan(fid, '%s%f', 1);
%                 line8 = textcan(fid, '%s%d', 1);
%                 
%             line7 = textscan(fid, '%s%d%d', 1);     % NODE
%             line8 = textscan(fid, '%s%d', 1);       % ARCVECTICES
%             j = j + 1;
%             ARC(j).id = line1{2};
%             ARC(j).elevation = line2{2};
%             ARC(j).nodes = [line7{2} line7{3}];
%             ARC(j).n = line8{2};
%             data = textscan(fid, '%f%f%f', ARC(j).n);
%            	ARC(j).x = data{1};
%             ARC(j).y = data{2};
%             ARC(j).h = data{3};
%             fgetl(fid);
%             fgetl(fid);
            
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

        
end

function [var, str] = read_line(line)
    line = strtrim(line);
    k = strfind(line, ' ');
    k = k(1);
    str = line(1:k-1);
    var = str2num(line(k+1:end));   
end
