%==========================================================================
% Read FVCOM sigma file (ASCII)
%
% input  :
%   fsigma
% 
% output :
%   sigma
%     UNIFORM
%       |--- nz
%       |--- type
%     GEOMETRIC
%       |--- nz
%       |--- type
%       |--- sigma_power
%     TANH
%       |--- nz
%       |--- type
%       |--- du
%       |--- dl
%     GENERALIZED
%       |--- nz
%       |--- type
%       |--- du
%       |--- dl
%       |--- min_const_depth
%       |--- ku
%       |--- kl
%       |--- zku
%       |--- zkl
%
%
% Siqi Li, SMAST
% 2022-11-30
%
% Updates:
%
%==========================================================================
function sigma = read_sigma(fsigma)



fid = fopen(fsigma);
lines = textscan(fid, '%s', 'Delimiter', '\n');
lines = strtrim(lines{1});
fclose(fid);

% Remove the commented lines and blank lines
for i = length(lines) : -1 : 1
    if startsWith(lines{i}, '!') || isempty(lines{i})
        lines(i) = [];
        continue
    end
    k = strfind(lines{i}, '!');
    if ~isempty(k)
        lines{i} = lines{i}(1:k(1)-1);
    end
end

% Read the parameters
for i = 1 : length(lines)
    if strfind(lines{i}, 'NUMBER OF SIGMA LEVELS')
        [~, sigma.nz] = read_line(lines{i});
        continue
    end
    if strfind(lines{i}, 'SIGMA COORDINATE TYPE')
        [~, sigma.type] = read_line(lines{i});
        sigma.type = upper(sigma.type);
        continue
    end
    %---------------------UNIFORM------------------------------
    % None

    %---------------------GEOMETRIC----------------------------
    if strfind(lines{i}, 'SIGMA POWER')
        [~, sigma.sigma_power] = read_line(lines{i});
        continue
    end

    %---------------------TANH----------------------------
    % DU, DL are in the GENERALIZED part

    %---------------------GENERALIZED--------------------------
    if strfind(lines{i}, 'DU')
        [~, sigma.du] = read_line(lines{i});
        continue
    end
    if strfind(lines{i}, 'DL')
        [~, sigma.dl] = read_line(lines{i});
        continue
    end
    if strfind(lines{i}, 'MIN CONSTANT DEPTH')
        [~, sigma.min_const_depth] = read_line(lines{i});
        continue
    end
    if strfind(lines{i}, 'ZKU')
        [~, sigma.zku] = read_line(lines{i});
        continue
    end
    if strfind(lines{i}, 'ZKL')
        [~, sigma.zkl] = read_line(lines{i});
        continue
    end
    if strfind(lines{i}, 'KU')
        [~, sigma.ku] = read_line(lines{i});
        continue
    end
    if strfind(lines{i}, 'KL')
        [~, sigma.kl] = read_line(lines{i});
        continue
    end
end


end

function [var, data] = read_line(string)

% Remove the blanks
string = strtrim(string);

% Remove the last comma, if any
if strcmp(string(end), ',')
    string = strtrim(string(1:end-1));
end

% Use = as a boundary between the variable names and their values
k = strfind(string, '=');

if isempty(k)
    disp(string)
    error('There is no = in this string.')
end

var = strtrim(string(1:k-1));
str0 = strtrim(string(k+1:end));



[X, tf] = str2num(str0);
if (tf)                                          % Numeric
    if contains(str0, '*')
        data = str2array_fortran(str0);
    else
        data = X;
    end
else      
    str1 = upper(str0);
    str1 = strrep(str1, '.TRUE.', 'T');
    str1 = strrep(str1, 'TRUE', 'T');
    str1 = strrep(str1, '.FALSE.', 'F');
    str1 = strrep(str1, 'FALSE', 'F');
    cell1 = textscan(str1, '%s', 'Delimiter', ',');
    if all(ismember(cell1{:}, {'T', 'F'}))      % Logical
        cell1 = cell1{:};
        for ii = 1 : length(cell1)
            if strcmp(cell1{ii}, 'T')
                data(ii) = true;
            elseif strcmp(cell1{ii}, 'F')
                data(ii) = false;
            else
                disp(str0)
                disp(cell1{:})
                error('Unknow line.')
            end
        end
    else                                        % Strings
        % First remove the useless quots
        str2 = str0;
        str2 = strrep(str2, char(39), '');
        cell2 = textscan(str2, '%s', 'Delimiter', ',');
        data = convertCharsToStrings(cell2{:})';
    end
end
% Logical

% Strings
        
% % 
% % if isempty(data)
% %     return
% % end
% % 
% % % For some certain variables:
% % list = {'RIVER_VERTICAL_DISTRIBUTION', ...
% %         'STARTUP_T_VALS',              ...
% %         'STARTUP_S_VALS'};
% % if any(strcmp(var, list))
% %     data = str2array_fortran(data);
% %     return
% % end
% % 
% % % String
% % if strcmp(data(1), "'") && strcmp(data(end), "'")
% %     data = strtrim(data(2:end-1));
% %     return
% % end
% % 
% % 
% % tmp = str2double(data);
% % if ~isnan(tmp)
% %     
% %     % Number
% %     data = tmp;
% % else
% %     
% %     % Logical
% %     if strcmp(data, 'T')
% %         data = true;
% %     elseif strcmp(data, 'F')
% %         data = false;
% %     end
% % end

end
