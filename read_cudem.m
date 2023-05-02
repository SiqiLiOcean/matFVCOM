%==========================================================================
% matFVCOM package
%   Read CUDEM dataset
%
% input  :
%   demdir
%   xlims
%   ylims
%   dd
%
% output :
%
% Siqi Li, SMAST
% 2023-04-26
%
% Updates:
%
%==========================================================================
function [xx, yy, zz] = read_cudem(demdir, xlims, ylims, dd)

% Longitude and latitude of each tile.
dd0 = 0.25;


x = xlims(1) : dd : xlims(2);
y = ylims(1) : dd : ylims(2);
[yy, xx] = meshgrid(y, x);


files = dir([demdir '/*.tif']);

ifile = 0;
for i = 1 : length(files)
    fname = files(i).name;
    k = strfind(fname, '_');
    str1 = fname(k(1)+1:k(2)-1);
    str2 = fname(k(2)+1:k(3)-1);
    % Get longitude
    lon1 = str2double(str2(2:4)) + str2double(str2(6:7))/100;
    if strcmp(str2(1), 'w')
        lon1 = -lon1;
    end
    lon2 = lon1 + dd0;
    % Get latitude
    lat2 = str2double(str1(2:3)) + str2double(str1(5:6))/100;
    if strcmp(str1(1), 's')
        lat2 = -lat2;
    end
    lat1 = lat2 - dd0;
    
    % Check if this file is in domain.
    if all([lon1<=xlims(2) lon2>=xlims(1) lat1<=ylims(2) lat2>=ylims(1)])
        ifile = ifile + 1;
        dem(ifile).file = convertCharsToStrings([files(i).folder '/' files(i).name]);
        dem(ifile).bounds = [lon1 lat1; lon2 lat2];
        dem(ifile).bdy_x = [lon1 lon2 lon2 lon1 lon1 nan];
        dem(ifile).bdy_y = [lat1 lat1 lat2 lat2 lat1 nan];
    end
end

if isempty(dem)
    error('There is no tile file for the selected region.')
end

n = length(dem);
disp(['There are totally ' num2str(n) ' files covering the domain.'])


zz = nan(size(xx));
for i = 1 : n
    disp([dem(i).file]')
    [xx0, yy0, zz0] = read_tiff(dem(i).file, 'Increase');

    ix = x>=xx0(1,1) & x<=xx0(end,1);
    iy = y>=yy0(1,1) & y<=yy0(1,end);
    zz(ix, iy) = interp_bilinear(zz0, xx0(:,1), yy0(1,:), x, y, 'Shrink');
end