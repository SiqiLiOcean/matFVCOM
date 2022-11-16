%==========================================================================
% Read the river names and grid locations from FVCOM river nml.
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
% 2021-11-20
%
% Updates:
%
%==========================================================================
function river = read_river_nml(fnml)



i1 = 0;
i2 = 0;

fid = fopen(fnml);

while ~feof(fid)
    
    line = strtrim(fgetl(fid));
    
% %     %     if strcmp(line(1), '!')
% %     if ~isempty(line) && strcmp(line(1), '!')
% %         fprintf(fid2, '%s\n', line);
% %         continue
% %     end
    
    % Remove the comments.
    k = strfind(line, '!');
    if ~isempty(k)
        line = line(1:k-1);
    end

    
    if contains(line, 'RIVER_NAME')
        k = strfind(line, "'");
        i1 = i1 + 1;
        river(i1).name = line(k(1)+1:k(2)-1);
    end

    if contains(line, 'RIVER_GRID_LOCATION')
        k = regexp(line, '[0-9]');
        i2 = i2 + 1;
        river(i2).loc = str2double(line(k));
    end
    
end



fclose(fid);

disp(' ')
disp('------------------------------------------------')
disp(['River #: ' num2str(length(river))])
disp(['RIVER_NAME              RIVER_INFLOW_LOCATION'])
for i = 1: length(river)
    fprintf('%20s  %8d\n', river(i).name, river(i).loc);
end
disp('------------------------------------------------')
disp(' ')

