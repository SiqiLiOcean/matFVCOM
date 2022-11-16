%==========================================================================
% Read the FVCOM grd input file (ASCII)
%      or
%      the SMS grd input file (ASCII)
%
% input  : grd path and name
% output : x  (x coordinate)
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
% Siqi Li, SMAST
% 2020-06-25
%
% Updates:
% 2020-07-16   Siqi Li, Added the cal_resolution step at the end.
% 2021-11-18   Siqi Li, Read h if there is h in output.
%==========================================================================
function [x, y, nv, h] = read_grd(finput)

% Check the version of the grd: FVCOM or SMS?
fid = fopen(finput);
line = fgetl(fid);
if ~contains(line, '=')
    version = 'SMS';
else
    version = 'FVCOM';
end
fclose(fid);

switch version
    case 'SMS'
        fid=fopen(finput);
        % First time, reading the input to get the node and nele
        node = 0;
        nele = 0;
        while (~feof(fid))
            line = fgetl(fid);
            num = length(str2num(line));
            if (num == 4)
                node = node + 1;
            else
                nele = nele + 1;
            end
        end
        
        frewind(fid);
        % Second time, read the x, y, nv
        % Read the nv
        data=textscan(fid,'%d %d %d %d %d',nele);
        nv=cell2mat(data(:,2:4));
        % Read the coordinate
        data=textscan(fid,'%d %f %f %f',node);
        x=cell2mat(data(:,2));
        y=cell2mat(data(:,3));
        if nargout>3
            h = cell2mat(data(:,4));
        end
        fclose(fid);
        
    case 'FVCOM'
        disp('FVCOM')
        fid=fopen(finput);
        % Read the node number
        line=textscan(fid,'%s %s %s %d',1);
        node=line{4};
        % Read the nele number
        line=textscan(fid,'%s %s %s %d',1);
        nele=line{4};
        % Read the nv
        data=textscan(fid,'%d %d %d %d %d',nele);
        nv=cell2mat(data(:,2:4));
        % Read the coordinate
        data=textscan(fid,'%d %f %f %f',node);
        x=cell2mat(data(:,2));
        y=cell2mat(data(:,3));
        if nargout>3
            h = cell2mat(data(:,4));
        end
        fclose(fid);
end

fprintf('==========================================\n')
fprintf(' Reading the %s \n', finput)
fprintf(' node #: %d \n', node)
fprintf(' cell #: %d \n', nele)
fprintf(' x range: %f ~ %f \n', min(x), max(x))
fprintf(' y range: %f ~ %f \n', min(y), max(y))
if nargout>3
    fprintf(' h range: %f ~ %f \n', min(h), max(h))
end

f_calc_resolution(x, y, nv);

