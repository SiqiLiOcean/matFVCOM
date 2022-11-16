%==========================================================================
% Replace the node id in the river nml fiel
% 
% Input  : f1 --- source fvcom grid
%          fnml1 --- source fvcom river nml
%          f2 --- destination fvcom grid
%          fnml2 --- destination fvcom river nml
%
% Output : node1 --- river node in source fvcom grid
%          node2 --- river node in destination fvcom grid
%          dist  --- the distance between node1 and node2
% 
% Usage  : [node1, node2, dist] = replace_river_nml(f1, fnml1, f2, fnml2);
%
% v1.0
%
% Siqi Li
% 2021-06-20
%
% Updates:
% 2021-06-21  Lu Wang  fixed the error when there is a blank line
%==========================================================================
function [node1, node2, dist] = replace_river_nml(f1, fnml1, f2, fnml2)




fid1 = fopen(fnml1);

fid2 = fopen(fnml2, 'w');

% First read the 'RIVER_INFLOW_LOCATION'
while ~feof(fid1)
    
    line = strtrim(fgetl(fid1));
    
    if strcmp(line(1), '!')
        continue
    end
    
    if contains(line, 'RIVER_INFLOW_LOCATION')
        if contains(line, 'node')
            RIVER_INFLOW_LOCATION = 'node';
        elseif contains(line, 'cell')
            RIVER_INFLOW_LOCATION = 'cell';
        else
            error('Unknown RIVER_INFLOW_LOCATION')
        end
        
        break
    end
    
end



% Find the boundary of f2
[~, ~, ~, ~, bdy_node] = f_calc_boundary(f2);
bdy_node = [bdy_node{:}];
bdy_x = f2.x(bdy_node);
bdy_y = f2.y(bdy_node);


% Second, read the 'RIVER_GRID_LOCATION'
i = 0;
frewind(fid1);
while ~feof(fid1)
    
    line = strtrim(fgetl(fid1));
    
    %     if strcmp(line(1), '!')
    if ~isempty(line) && strcmp(line(1), '!')
        fprintf(fid2, '%s\n', line);
        continue
    end
    
    if contains(line, 'RIVER_GRID_LOCATION')
        k = regexp(line, '[0-9]');
        i = i + 1;
        
        node1(i) = str2double(line(k));
        [j, dist(i)] = knnsearch([bdy_x bdy_y], [f1.x(node1(i)), f1.y(node1(i))]);
        node2(i) = bdy_node(j);
        
        new_line = [line(1:min(k)-1) num2str(node2(i)) line(max(k)+1:end)];
        fprintf(fid2, '%s\n', new_line);
        
    else
        fprintf(fid2, '%s\n', line);
    end
    
end

        
fclose(fid1);
fclose(fid2);


disp(' ')
disp('------------------------------------------------')
disp(['River #: ' num2str(length(node1))])
disp(['RIVER_INFLOW_LOCATION: ' RIVER_INFLOW_LOCATION])
disp('  Node 1  |  Node 2  |  Distance')
for i = 1: length(node1)
    fprintf('%8d  |%8d  |%10.5f\n', node1(i), node2(i), dist(i));
end
disp('------------------------------------------------')
disp(' ')

