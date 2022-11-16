%==========================================================================
% Merge two nameslits
%
% input  :
%   nml0 --- the default namelist
%   nml1 --- the input namelist
% 
% output :
%   nml2 --- the contents are based on namelist0; different ones are 
%            modified and new ones are added from namelist1.
%
% Siqi Li, SMAST
% yyyy-mm-dd
%
% Updates:
%
%==========================================================================
function nml2 = merge_nml(nml0, nml1)


nml2 = nml0;

group_names1 = fieldnames(nml1);
group_names0 = fieldnames(nml0);

for i1 = 1 : length(group_names1)
    
    clear msg
    [~, i0] = ismember(upper(group_names1(i1)), upper(group_names0));
    vars1 = getfield(nml1, group_names1{i1});
    var_names1 = fieldnames(vars1);
    
    if i0>0   % Find the group
        msg(1) = strcat("&", convertCharsToStrings(group_names1(i1)));
        
        vars0 = getfield(nml0, group_names0{i0});
        var_names0 = fieldnames(vars0);
        
        for j1 = 1 : length(var_names1)  
            [~, j0] = ismember(upper(var_names1{j1}), upper(var_names0));
            
            if j0>0   % Find the varaible
                cmd = ['nml2.' group_names0{i0} '.' var_names0{j0} '= nml1.' group_names1{i1} '.' var_names1{j1} ';'];
                eval(cmd);
            else      % Not find the variable
                msg(end+1) = strcat("   ", convertCharsToStrings(var_names1{j1}));
            end
        end
        
    else     % Not find the group
        
        msg(1) = strcat("&", convertCharsToStrings(group_names1{i1}), "   (NEW)");
        for j1 = 1 : length(var_names1)
            cmd = ['nml2.' group_names1{i1} '.' var_names1{j1} ' = nml1.' group_names1{i1} '.' var_names1{j1} ';'];
            eval(cmd);
            msg(end+1) = strcat("   ", convertCharsToStrings(var_names1{j1}));
        end
    end
    
    if length(msg) > 1
        for imsg = 1 : length(msg)
            disp(msg(imsg))
        end
    end
    

                
end
    