%==========================================================================
% Write Fortran nml file
%
% input  :
%   fnml --- output nml file path and name
%   nml  --- nml struct
%   options
%     --- 'OldStyle', write the float array in old style .
%     --- 'EndComma', the variable lines are ended with a comma.
%     --- 'WithQuote', all the strings are with quotes.
% output :
%   \
%
% Siqi Li, SMAST
% 2022-03-17
%
% Updates:
%
%==========================================================================
function write_nml(fnml, nml0, varargin)

varargin = read_varargin2(varargin, {'OldStyle'});
varargin = read_varargin2(varargin, {'EndComma'});
varargin = read_varargin2(varargin, {'WithQuote'});
varargin = read_varargin2(varargin, {'Append'});



if ~isempty(EndComma)
    EndSymbol = ',';
else
    EndSymbol = '';
end

if ~isempty(WithQuote)
    StringSymbol = char(39);
else
    StringSymbol = [];
end

group_names = fieldnames(nml0);

% Get the longest varaible name.
len = 0;
for i = 1 : length(group_names)
    vars = getfield(nml0, group_names{i});
    var_names = fieldnames(vars);
    for j = 1 : length(var_names)
        len = max(len, length(var_names{j}));
    end
end

if ~isempty(Append)
    fid = fopen(fnml, 'a+');
else
    fid = fopen(fnml, 'w');
end
for i = 1 : length(group_names)

    vars_all = getfield(nml0, group_names{i});

    for l = 1 : length(nml0.(group_names{i}))
        vars = vars_all(l);
        fprintf(fid, '%s%s\n', '&', group_names{i});
        var_names = fieldnames(vars);

        for j = 1 : length(var_names)
            var_name = var_names{j};
            var_data = getfield(vars, var_name);

            format = ['%s%' num2str(len) 's %s '];
            var_name = strjust(sprintf(['%'  num2str(len) 's'], var_name), 'left');
            fprintf(fid, format, ' ', var_name, '=');

            switch class(var_data)
                case {'double', 'int32'} 
                    if all(floor(var_data)==var_data)
                        for k = 1 : length(var_data)
                            fprintf(fid, '%d%s', var_data(k), EndSymbol);
                        end
                    else
                        if ~isempty(OldStyle)
                            for k = 1 : length(var_data)
                                fprintf(fid, '%f%s', var_data(k), EndSymbol);
                            end
                        else
                            str = convert_float_new_style(var_data);
                            fprintf(fid, '%s%s', str, EndSymbol);
                        end
                    end

                case 'logical'
                    for k = 1 : length(var_data)
                        if var_data(k)
                            fprintf(fid, '%s%s', 'T', EndSymbol);
                        else
                            fprintf(fid, '%s%s', 'F', EndSymbol);
                        end
                    end

                case 'string'
                    for k = 1 : length(var_data)
                        fprintf(fid, '%s%s%s%s', StringSymbol, var_data(k), StringSymbol, EndSymbol);
                    end
                
                case 'char'
                    fprintf(fid, '%s', StringSymbol, var_data, StringSymbol, EndSymbol);

                otherwise
                    disp(var_data)
                    disp(class(var_data))
                    error('Unconsidered class.')

            end
            fprintf(fid, '\n');
        end
        fprintf(fid, '%s\n', '/');
    end
end

fclose(fid);


end

%==========================================================================
% Convert the float array in Fortran nml in a new style
%   
% Example: Old style  [1.0, 1.0, 1.0, 2.0, 2.0, 2.0, 3.0, 3.0 ]
%          New style  3*1.0, 3*2.0, 2*3.0
%
% Siqi Li, SMAST
% 2022-10-28
%==========================================================================
function str = convert_float_new_style(array)
i = 1;
j = 1;
var(j) = array(i);
n(i) = 1;

for i = 2 : length(array)
    if array(i) == var(j)
        n(j) = n(j) + 1;
    else
        j = j + 1;
        var(j) = array(i);
        n(j) = 1;
    end
end

str = [];
for j = 1 : length(n)
    str = [str num2str(n(j), '%d') '*', num2str(var(j), '%f')];
    if j<length(n)
        str = [str ', '];
    end
end
end