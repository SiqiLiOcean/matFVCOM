%==========================================================================
% Read gri-grd file
%
% input  :
%   fin  --- input gri-grd file name
%
% output :
%   out --- structure containing x1   (start x) 
%                                 x2   (end x)
%                                 y1   (start y)
%                                 y2   (end y)
%                                 nx   (x dimension length)
%                                 ny   (y dimension length)
%                                 data (data, in size of (ny, nx))
% Siqi Li, SMAST
% 2022-02-17
%
% Attention!
% In Gri-grd, the x varies in column and y varies in row.
%       x1  x2  x3 ....
%   y1
%   y2
%   y3
%    :
%    :
%
% Updates:
%
%==========================================================================
function out = read_gri_grd(fin)

i = 0;
fid = fopen(fin);

while ~feof(fid)
    fgetl(fid);
    %
    line = textscan(fid, '%d %d\n', 1);
    nx = line{1};
    ny = line{2};
    %
    line = textscan(fid, '%f %f\n', 1);
    x1 = line{1};
    x2 = line{2};
    %
    line = textscan(fid, '%f %f\n', 1);
    y1 = line{1};
    y2 = line{2};
    %
    format = [repmat('%f', 1, nx) '\n'];
    data = cell2mat(textscan(fid, format, ny));
    
    i = i + 1;
    out(i,1).nx = nx;
    out(i,1).ny = ny;
    out(i,1).x1 = x1;
    out(i,1).x2 = x2;
    out(i,1).y1 = y1;
    out(i,1).y2 = y2;
    out(i,1).data = data;
    
end

fclose(fid);