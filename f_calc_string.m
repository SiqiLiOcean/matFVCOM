%==========================================================================
% Calculate the strings of FVCOM grid
%
% input  :
%   fgrid
% 
% output :
%   string --- node id of each string
%
% Siqi Li, SMAST
% 2021-11-18
%
% Updates:
%
%==========================================================================
function string = f_calc_string(fgrid)




lines = fgrid.lines;
n = size(lines, 1);
flag = ones(n, 1);



disp('String id    Line #    Accumulated line #     Total line #')
i = 0;
num = 0;
while sum(flag)>0
    
    i = i + 1;
    
    % Find the first unused line
    k = find(flag, 1, 'first');
    
    % Set the first two nodes of the new string
    string1 = lines(k, :);
    flag(k) = 0;
    
    % Extend the string
    while 1
        found = find((flag==1 & lines(:,1)==string1(end)), 1, 'first');
        
        if isempty(found)
            break
        else
            flag(found) = 0;
            string1 = [string1 lines(found,2)];
        end
        
    end   
    
    string{i,1} = string1;
    num = num + length(string1) - 1;
    
    if mod(i, 1000) == 0
        disp([i, length(string1) - 1, num, n])
    end
end
