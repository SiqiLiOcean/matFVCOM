%==========================================================================
% Write FVCOM station time-series input data
%
% input  :
%   sta  --- observation cell
%              |-- x
%              |-- y
%              |-- node / cell
%              |-- h
%              |-- name
%   fout --- FVCOM station time-series input data
%
% output :
%
% Siqi Li, SMAST
% 2024-03-06
%
% Updates:
%==========================================================================
function write_station2(sta, fout, varargin)

varargin = read_varargin(varargin, {'Type'}, {'node'});

n = length(sta);
fid = fopen(fout, 'w');
% Header line
switch Type
    case 'node'
        fprintf(fid, '%s\n', '      No                    X                    Y     Node      Depth          StationName');
    case 'cell'
        fprintf(fid, '%s\n', '      No                    X                    Y     Cell      Depth          StationName');
end
% Station information
for i = 1 : n
    switch Type
        case 'node'
            fprintf(fid, '%8d %20.6f %20.6f %8d %10.2f %20s\n', ...
                i, sta(i).x, sta(i).y, sta(i).node, sta(i).h, sta(i).name);
        case 'cell'
            fprintf(fid, '%8d %20.6f %20.6f %8d %10.2f %20s\n', ...
                i, sta(i).x, sta(i).y, sta(i).node, sta(i).h, sta(i).name);
        otherwise
            error('Wrong type. Select either ''node'' or ''cell''')
    end
end

fclose(fid);
