%==========================================================================
% Read the varargin in the function input (style 1)
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
%
%==========================================================================
function out = read_varargin(in, s_name, s_default)

n = length(s_name);

% Set the default values
for i = 1 : n
    assignin('caller', s_name{i}, s_default{i});
end

j = 1;
out = in;
while j < length(out)
    k = find(strcmpi(s_name, out{j}));
    
    if k > 0  % the option name is in the list
        assignin('caller', s_name{k}, out{j+1});
        out(j:j+1) = [];
%         j = j-2;
    else
        j = j+1;

    end
    
%     j = j + 2;
        
end

end