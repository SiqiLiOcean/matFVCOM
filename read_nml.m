%==========================================================================
% Read nml file
%
% input  :
%   fnml --- namelist file
%
% output :
%   nml  --- namelist data in struct
%
% Siqi Li, SMAST
% 2022-03-17
%
% Updates:
%
%==========================================================================
function nml = read_nml(fnml)


fid = fopen(fnml);
C = textscan(fid, '%s', 'Delimiter', '\n');
C = C{1};
fclose(fid);


% 1. Remove the comments
for i = 1 : length(C)
    
    k = strfind(C{i}, '!');
    if ~isempty(k)
        C{i}(k(1):end) = [];
    end
    
end

% 2. Trim the lines and remove the empty lines
for i = length(C) : -1 : 1

    C{i} = strtrim(C{i});
    
    if isempty(C{i})
        C(i) = [];
    end

end


% 3. Find the start-line and end-line of each section
n = 0;
i = 1;
in_section = 0;
while i <= length(C)
    
    if in_section == 0
        
        if strcmp(C{i}(1), '&')
            n = n + 1;
            section{n,1} = strtrim(C{i}(2:end));
            i1(n,1) = i;
            in_section = 1;
        end
        
    else
        
        if strcmp(C{i}(1), '/')
            i2(n,1) = i;
            in_section = 0;
        end
        
    end
    
    i = i + 1;
    
end
        

if length(i1) ~= length(i2)
    error('The & number is not equal to / number')
end


% 4. Combine the lines that should be together
for i = n : -1 : 1
    for j = i2(i)-1 : -1 : i1(i)+2
         if ~contains(C{j}, '=')
             C{j-1} = [C{j-1} C{j}];
             C(j) = [];
             i1(i+1:end) = i1(i+1:end)-1;
             i2(i:end) = i2(i:end)-1;
         end
    end
end
             

nml = [];
for i = 1 : n

    if isfield(nml, section{i})
        cmd = ['k = length(nml.' section{i} ');'];
        eval(cmd);
    else
        k = 0;
    end
    for j = i1(i)+1 : i2(i)-1
        [var, data] = read_line(C{j});
        
        cmd = ['nml.' section{i} '(k+1).' var ' = data;'];
        eval(cmd);
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




function array = str2array_fortran(str)

C = textscan(str, '%s', 'Delimiter', ',');
C = C{1};

array = [];
for i = 1 : length(C)
    
    if contains(C{i}, '*')
        k = strfind(C{i}, '*');
        n = str2double(C{i}(1:k-1));
        val = str2double(C{i}(k+1:end));
        array = [array repmat(val, 1, n)];
    else
        array = [array str2double(C{i})];
    end
    
end

end
