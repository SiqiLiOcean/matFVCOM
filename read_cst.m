%==========================================================================
% Read the coastline in cst format
% 
% Input  :
%   --- fout, output cst file
% Output :
%   --- cst
%     --- x, x of coastlines
%     --- y, y of coastlines
%

% 
% Usage  : write_cst(fout, cst_x, cst_y);
%
% v1.0
%
% Siqi Li
% 2021-04-14
%
% Updates:
%
%==========================================================================
function cst = read_cst(fcst)

fid = fopen(fcst);

fgetl(fid);  % COAST
data = textscan(fid, '%d %f', 1);
n = data{1};

for i = 1 : n
    data = textscan(fid, '%d %f', 1);
    m = data{1};
    data = textscan(fid, '%f %f %f', m);
    cst(i).x = [data{1}' nan];
    cst(i).y = [data{2}' nan];
end
fclose(fid);


