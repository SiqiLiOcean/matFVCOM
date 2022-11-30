%==========================================================================
% Merge multiple fiels into one with pre-calculated index
%
% input  :
%   index  --- results from f_nesting_merge1
%   var_in --- cell for variables of different grids
% 
% output :
%   var    --- the merged field
%
% Siqi Li, SMAST
% 2021-11-02
%
% Updates:
%
%==========================================================================
function var = f_nesting_merge2(index, var_in) 

n = length(index);

flag = nan(n, 1);
for i = 1 : n
    flag(i) = length(var_in{i}) > max(index(i).jnode);
end

if all(flag)
    type = 'cell';
else
    type = 'node';
end
    

switch lower(type)
    
    case 'node'
        for i = 1 : n
            var(index(i).inode, :, :) = var_in{i}(index(i).jnode, :, :);
        end
        
    case 'cell'
        for i = 1 : n
            var(index(i).icell, :, :) = var_in{i}(index(i).jcell, :, :);
        end
        
    otherwise
        error('The 1st dimension lenght is wrong.')
        
end