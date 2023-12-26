%==========================================================================
% Move the data to sharp hour: Only calculate the index
%
%      04:50         06:00                   08:07
% -------x-------------x-----------------------x----
%      data1         data2                   data3
%
%         05:00      06:00      07:00      08:00
% ----------+----------+----------+----------+------
%         data1      data2       nan       data3
%
% The selected window length can be set.
%
% Input  : --- time0, the input time (MATLAB datenum format)
%          --- data0, the input data
%          --- varargin{1}, time limits
%          --- varargin{2}, the window length in minute, the default
%                is 15 min
%      
% Output : --- time, the output time (MATLAB datenum format)
%          --- data, the output data
% 
% Usage  : [time, data] = data_hourly(time0, data0, 10);
%
% v1.0
%
% Siqi Li
% 2021-05-26
%
% Updates:
%
%==========================================================================
function  [time, data] = data_random2hourly(time0, data0, varargin)

% [time, i1, i2] = data_hourly_calc_index(time0, varargin{:});
% data = data_hourly_via_index(i1, i2, data0);

% tlim = [];
% Twindow = 15;
% 
% if nargin == 3
%     tlim = varargin{1};
%     if sum(tlim<3000)==2
%         tlim(1) = datenum(tlim(1), 1, 1);
%         tlim(2) = datenum(tlim(2)+1, 1, 1) - 1/60/60/24;
%     end
% end
% if nargin == 4
%     tlim = varargin{1};
%     if sum(tlim<3000)==2
%         tlim(1) = datenum(tlim(1), 1, 1);
%         tlim(2) = datenum(tlim(2)+1, 1, 1) - 1/60/60/24;
%     end
%     Twindow = varargin{2};
% end

varargin = read_varargin(varargin, {'Tlims'}, {[]});
varargin = read_varargin(varargin, {'Twindow'}, {15});



% time0 = buoy1(1).time;
% data0 = buoy1(1).wspd;


if isempty(Tlims)
    
    t1 = min(time0);
    t2 = max(time0);
    
    tvec1 = datevec(t1);
    tvec1(5:6) = 0;
    tvec2 = datevec(t2);
    tvec2(4) = tvec2(4) + 1;
    tvec2(5:6) = 0;
    
    
    time = datenum(tvec1) : 1/24 : datenum(tvec2);
    time = time(:);
    
else
    time = Tlims(1) : 1/24 : Tlims(2);
    time = time(:);
end

if isempty(time0) && isempty(data0)
    time0 = time;
    data0 = nan*time;
end


[i1, dt] = ksearch(time0(:), time);
dt = dt * 24 * 60;

i2 = find(dt<=Twindow);
i1(dt>Twindow) = [];

% margin = i2(1) - 1;
% i2 = i2 - margin;
% time(1:margin) = [];
% if i2(end) < length(time)
%     time(i2(end)+1:end) = [];
% end


% % % data = nan(i2(end), 1);
% % % 
% % % data(i2) = data0(i1);
data = time*nan;
data(i2) = data0(i1);

% data = data0(i1);
% data(dt>Twindow) = nan;

% if ~isempty(tlim)
%     k = find(time>=tlim(1) & time<=tlim(2));
%     time = time(k);
%     data = data(k);
% end