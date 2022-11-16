%==========================================================================
% Extract variables from a struct
%
% input  :
%   S         --- input struct
%   var_names --- extracted variable names (optional)
%
% output :
%
% Siqi Li, SMAST
% 2022-03-22
%
% Updates:
%
%==========================================================================
function S2 = struct_extract(S, var_names)

var_names0 = fieldnames(S);

if ~exist('var_names', 'var')
    var_names = var_names0;
end


for i1 = 1 : length(var_names)
    
    [~, i0] = ismember(upper(var_names{i1}), upper(var_names0));
    
    if i0>0
        if nargout == 0
            cmd = ['assignin(' char(39) 'caller' char(39) ',' char(39) convertStringsToChars(var_names{i1}) char(39) ', S.' var_names0{i0} ');'];
            eval(cmd);
        else
            cmd = ['S2.' convertStringsToChars(var_names{i1}) ' = S.' var_names0{i0} ';'];
            eval(cmd);
        end
    else
        disp(var_names0)
        error([char(39) var_names{i1} char(39) ' not exist.'])
    end
end

% assignin('caller', inputname(1), fgrid)