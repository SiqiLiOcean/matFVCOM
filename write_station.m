%==========================================================================
% Write FVCOM station file
%
% input  :
%   fout    --- output file path and name
%   fgrid   --- fvcom grid struct
%   x       --- Station x
%   y       --- Station y
%   'Type'  --- 'Node' or 'Cell' (optional, default is 'Node')
%   'Id'    --- integer array of Id list (optional, default is the nearest
%               node or cell
%   'Depth' --- Station depth array (optional, default is the depth of 
%               selected nodes or cells)
%   'Name'  --- Station name (optional, default is from 1 to n)
% output :
%
% Siqi Li, SMAST
% 2022-03-16
%
% FVCOM station file example:
% No X Y Node Depth (m) Station Name
% 1 -85.66666 30.15167 170 27.49 '8729108 Panama City, FL'
% 2 -86.49333 30.50333 50759 2.29 '8729501 Valparaiso, FL '
% 3 -87.21167 30.40333 59185 7.66 '8729840 Pensacola, FL '
% 4 -87.42834 30.38667 39686 4.41 '8729941 Blue Angles PK, FL '
% 5 -87.68333 30.27833 40673 5.50 '8731439 Gulf Shores ICWW, AL'
%
% Updates:
%
%==========================================================================
function write_station(fout, fgrid, x, y, varargin)

varargin = read_varargin(varargin, {'Type'}, {'Node'});
n = length(x);
switch upper(Type)
    case 'NODE'
        [id0, d] = f_find_nearest(fgrid, x, y, Type);
        depth0 = fgrid.h(id0);
    case 'CELL'
        [id0, d] = f_find_nearest(fgrid, x, y, Type);
        depth0 = fgrid.hc(id0);
    otherwise
        error('WRONG Type. Use node or cell.')
end
for i = 1 : n
    name0{i} = num2str(i);
end

varargin = read_varargin(varargin, {'Id'}, {id0});
varargin = read_varargin(varargin, {'Depth'}, {depth0});
varargin = read_varargin(varargin, {'Name'}, {name0});


fid = fopen(fout, 'w');
fprintf(fid, '%s\n', 'No   X   Y   Node   Depth (m)   Station Name');
str = sprintf('%6s %10s %14s %10s %s', 'Index', 'Id', 'O-M Distance', 'Depth', 'Name');
disp(str);
for i = 1 : n
    fprintf(fid, '%6d %14.6f %14.6f %10d %10.2f %s\n', ...
                   i, x(i), y(i), Id(i), Depth(i), Name{i});
    str = sprintf('%6d %10d %14.6f %10.2f %s', i, Id(i), d(i), Depth(i), Name{i});
    disp(str);
end
fclose(fid);