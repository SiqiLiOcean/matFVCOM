%==========================================================================
% Read WRF-Hydro data
%
% input  :
%   prefix   --- wrf-hydro output prefix
%   time_fmt --- wrf-hydro output time format
%   postfix  --- wrf-hydro output postfix
%   t1       --- start time (in datenum)
%   t2       --- end time (in datenum)
%   dt       --- time interval in day
%   varname  --- variable name
%   Start    --- start time index
%   Count    --- time count number
%   Stride   --- time stride
%
% output :
%   data     ---
%
% Siqi Li, SMAST
% 2022-05-23
%
% Updates:
%
%==========================================================================
function data = h_load_data(prefix, time_fmt, postfix, t1, t2, dt, varname, varargin)


time = t1 : dt : t2;
nt = length(time);

% Check the dimension of the selected variable
fin = [prefix datestr(time(1), time_fmt) postfix];
[~, dim_name] = nc_get_var_dim(fin, varname);
is_time = contains(dim_name, 'time');

if sum(is_time) > 0   % There is a time dimension
%     dims = dim_length;
    t_dim = length(dim_name);
    varargin = read_varargin(varargin, {'Start'}, {ones(1, t_dim-1)});
    varargin = read_varargin(varargin, {'Count'}, {Inf(1, t_dim-1)});
    varargin = read_varargin(varargin, {'Stride'}, {ones(1, t_dim-1)});
    Start = [Start 1];
    Count = [Count Inf];
    Stride = [Stride 1];

else                  % There is no time dimension
%     dims = [dim_length 1];
    t_dim = length(dim_name) + 1;
    varargin = read_varargin(varargin, {'Start'}, {ones(1, t_dim-1)});
    varargin = read_varargin(varargin, {'Count'}, {Inf(1, t_dim-1)});
    varargin = read_varargin(varargin, {'Stride'}, {ones(1, t_dim-1)});    
end


for it = 1 : nt
    
    disp(['---' datestr(time(it), time_fmt)])
    fin = [prefix datestr(time(it), time_fmt) postfix];
    

    tmp = squeeze(ncread(fin , varname, Start, Count, Stride));

    
    if numel(tmp) == length(tmp)
        ndim = 1;
    else
        ndim = length(size(tmp));
    end
    cmd = ['data(' repmat(':,', 1,ndim) 'it) = tmp;'];
    eval(cmd);
end



