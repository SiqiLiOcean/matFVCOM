%==========================================================================
% Combine the variabels from multiple NetCDF files
% 
%
% input  :
%   fin_prefix --- input files prefix
%   varname    --- variable name
%   Time       --- time variable name
%   Lon        --- longitude variable name
%   lat        --- latitude variable name
% 
% output :
%   var        --- combined variable data
%   time       --- combined longitude data
%   longitude  --- longitude
%   latitude   --- latitude
%
% Siqi Li, SMAST
% 2023-01-04
%
% Updates:
%
%==========================================================================
function [var, time, lon, lat] = read_nc_combine(fin_prefix, varname, varargin)

varargin = read_varargin(varargin, {'Time'}, {'time'});
varargin = read_varargin(varargin, {'Lon'}, {'lon'});
varargin = read_varargin(varargin, {'Lat'}, {'lat'});



% fin_prefix = '/hosts/hydra.smast.umassd.edu/data3/siqili/help/Yu/gl/prepare/surface_forcing/input/air.2m.gauss.*.nc';
% varname = 'air';

files = dir(fin_prefix);

if length(files) == 0
    error('Wrong fin_prefix.')
end

varargin = read_varargin(varargin, {'File_start'}, {1});
varargin = read_varargin(varargin, {'File_stride'}, {1});
varargin = read_varargin(varargin, {'File_index'}, {File_start : File_stride : length(files)});

time = [];
var = [];

for i = File_index(:)'
    
    % File name
    fin = [files(i).folder '/' files(i).name];

    if i == File_index(1)
        varinfo = ncinfo(fin, varname);
        nDim = length(varinfo.Dimensions);
        info = ncinfo(fin);
        varlist = {info.Variables.Name};
        if any(strcmp(varlist, Lon))
            read_lon = true;
        else
            read_lon = false;
        end
        if any(strcmp(varlist, Lat))
            read_lat = true;
        else
            read_lat = false;
        end
        if any(strcmp(varlist, Time))
            read_time = true;
        else
            read_time = false;
        end
        if read_lon
            lon = ncread(fin, Lon);
        else
            lon = [];
        end
        if read_lat
            lat = ncread(fin, Lat);
        else
            lat = [];
        end
    end

    if read_time
        data = ncread(fin, Time);
        nt = length(data);
    else
        data = [];
        nt = varinfo.Dimensions(end).Length;
    end
    disp(['  --- ' files(i).name '  ' num2str(nt)])
    time = [time; data(:)];
    data = ncread(fin, varname);
    if i == File_index(1)
        eval(['var(' repmat(':,',1,nDim-1) '1:nt) = data;'])
    else
        eval(['var(' repmat(':,',1,nDim-1) 'end+1:end+nt) = data;'])
    end
end

% Sort the data in time
if read_time
    [time, kt] = sort(time, 'ascend');
    eval(['var = var(' repmat(':,',1,nDim-1) 'kt);'])
end

