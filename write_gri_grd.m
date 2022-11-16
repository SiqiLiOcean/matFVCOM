%==========================================================================
% Write gri-grd file
%
% input  :
%   fout --- output file path and name
%   data --- structure containing x1   (start x) 
%                                 x2   (end x)
%                                 y1   (start y)
%                                 y2   (end y)
%                                 nx   (x dimension length)
%                                 ny   (y dimension length)
%                                 data (data, in size of (ny, nx))
% 
% output : \
%
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
function write_gri_grd(fout, data)

n = length(data);
fid = fopen(fout, 'w');


for i = 1 : n
    fprintf(fid, '%s\n', 'DSAA');
    %
    fprintf(fid, '%d %d\n', data(i).nx, data(i).ny);
    fprintf(fid, '%16.6f %16.6f\n', data(i).x1, data(i).x2);
    fprintf(fid, '%16.6f %16.6f\n', data(i).y1, data(i).y2);
    %
    format = [repmat('%14.4e', 1, data(i).nx) '\n'];
    for j = 1 : data(i).ny
        fprintf(fid, format, data(i).data(j,:));
    end
end

fclose(fid);
