%==========================================================================
% Write the FVCOM grd input file (ASCII)
%
% input  : foutput (grd path and name)
%          x  (x coordinate)
%          y  (y coordinate)
%          nv (triangle matrix)
%          
% grd file format:
% Node Number = 32709
% Cell Number = 61355
%        1       7       1       2      1
%        2       7       6       1      1
%        3       6       3       1      1
%  ...
%        1   -73.2533490    45.1440438    0.00
%        2   -73.2509108    45.1431603    0.00
%  ...
%
%
% Siqi Li, SMAST
% 2020-07-23
% Updates
% 2022-12-27  Siqi Li  Set Fix_direction as an option (default is off)
% 2022-10-16  Siqi Li  Add h as an option input
%==========================================================================
function write_grd(fout, x, y, nv, h, varargin)

varargin = read_varargin2(varargin, {'Fix_direction'});

if ~isempty(Fix_direction)
    % Make sure the direction of cell nodes are counter clockwise
    tf = f_calc_grid_direction(x, y, nv);
    k = find(tf>0);
    if ~isempty(k)
        %     nv0 = nv;
        %     nv(k,2) = nv0(k,3);
        %     nv(k,3) = nv0(k,2);
        nv = nv(:, [1 3 2]);
        disp(' ')
        disp('------------------------------------------------')
        disp([num2str(length(k)) ' of ' num2str(size(nv,1)) ' cells are in ' ...
            'wrong direction (clockwise).'])
        disp('Have changed them to counter clockwise direction!')
        disp('------------------------------------------------')
        disp(' ')
    end
end

if ~exist('h', 'var')
    h = 0*x;
end

% Get the dimension
node = length(x);
nele = size(nv, 1);

% Create the new file.
fid=fopen(fout, 'w');

% Write the node number
fprintf(fid, '%s %d\n', 'Node Number =  ', node);
fprintf(fid, '%s %d\n', 'Cell Number =  ', nele);

% Write the coordinate
for i = 1 : nele
    fprintf(fid, '%8d %8d %8d %8d %8d\n', i, nv(i, :), 1);
end
for i = 1 : node
    fprintf(fid, '%8d %16.8f %16.8f %16.8f\n', i, x(i), y(i), h(i));
end

% Close the file.
fclose(fid);
