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

time = [];
var = [];
for i = 1 : length(files)
    
    % File name
    fin = [files(i).folder '/' files(i).name];
    

    if i == 1
        varinfo = ncinfo(fin, varname);
        nDim = length(varinfo.Dimensions);
        lon = ncread(fin, Lon);
        lat = ncread(fin, Lat);
    end

    data = ncread(fin, Time);
    nt = length(data);
    disp(['  --- ' files(i).name '  ' num2str(nt)])
    time = [time; data(:)];
    data = ncread(fin, varname);
    if i == 1
        eval(['var(' repmat(':,',1,nDim-1) '1:nt) = data;'])
    else
        eval(['var(' repmat(':,',1,nDim-1) 'end+1:end+nt) = data;'])
    end
end

% Sort the data in time
[time, kt] = sort(time, 'ascend');
eval(['var = var(' repmat(':,',1,nDim-1) 'kt);'])
