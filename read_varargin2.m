%==========================================================================
% Read the varargin in the function input (style 2)
%
% input  : in,        the varargin part
%          s_name,    a cell containing the setting name
%          s_default, a cell containing the seting default
% 
% output : out,       the rest varargin part
%
% Siqi Li, SMAST
% 2021-06-22
%
% Updates:
% 2022-03-01  Siqi Li  Change the TRUE to 'STR' and FALSE to ''.
%
%==========================================================================
function out = read_varargin2(in, s_name)

n = length(s_name);

% Set the default values
for i = 1 : n
    assignin('caller', s_name{i}, '');
%     assignin('caller', s_name{i}, 0);
end

j = 1;
out = in;
while j <= length(out)
    k = find(strcmpi(s_name, out{j}));

    if k > 0  % the option name is in the list
        assignin('caller', s_name{k}, s_name{k});
%         assignin('caller', s_name{k}, 1);
        out(j) = [];
        j = j-1;
    end
    
    j = j + 1;
        
end

end