%==========================================================================
% Deal with the data
%   - hourly
%   - daily mean
%   - monthly mean
%   - seasonal mean
%   - annual mean
% 
% Input  : --- time0, the input time (MATLAB time format)
%          --- data0, the input data
%          --- out_type, set as 'hourly', 'daily', 'monthly', 'seasonal',
%                'annual'
%          --- varargin{1}, tlim
%          --- varargin{2}, window length
%
% Output : --- time, the output seasonal time (MATLAB time format or year)
%          --- data, the output data
% 
% Usage  : 
%
% v1.0
%
% Siqi Li
% 2021-05-26
%
% Updates:
%
%==========================================================================
function [time, data] = data_mean(time0, data0, out_type, varargin)

% tlim = [];
% window = 15;
% 
% if nargin == 4
%     tlim = varargin{1};
% end
% if nargin == 5
%     tlim = varargin{1};
%     window = varargin{2};  
% end
varargin = read_varargin(varargin, {'tlim'}, {[]});
varargin = read_varargin(varargin, {'window'}, {15});



% time0 = buoy1(1).time;
% time0 = montht;
% data0 = buoy1(1).wspd;

tvec0 = datevec(time0);
dt = time0(2:end) - time0(1:end-1);

% Judge the input time type
if unique(tvec0(:,3))==1 & unique(tvec0(:,4:6)==0)
    in_type = 'monthly';
else
    if abs(unique(dt) - 1) < 1e-8
        in_type = 'daily';
    elseif abs(unique(dt) - 1/24) < 1e-8
        in_type = 'hourly';
    else
        in_type = 'random';
    end
end

    
    disp(['In type  : ' in_type])
    disp(['Out type : ' out_type])
    
switch in_type
    
    case 'random'
        switch out_type
            case 'random'
                stop(in_type, out_type)
            case 'hourly'
                [time, data] = data_random2hourly(time0, data0, tlim, window);
            case 'daily'
                [time1, data1] = data_random2hourly(time0, data0, tlim, window);
                [time, data] = data_hourly2daily(time1, data1, tlim);
            case 'monthly'
                [time1, data1] = data_random2hourly(time0, data0, tlim, window);
                [time2, data2] = data_hourly2daily(time1, data1, tlim);
                [time, data] = data_daily2monthly(time2, data2, tlim);
            case 'seasonal'
                [time1, data1] = data_random2hourly(time0, data0, tlim, window);
                [time2, data2] = data_hourly2daily(time1, data1, tlim);
                [time3, data3] = data_daily2monthly(time2, data2, tlim); 
                [time, data] = data_monthly2seasonal(time3, data3, tlim); 
            case 'annual'
                [time1, data1] = data_random2hourly(time0, data0, tlim, window);
                [time2, data2] = data_hourly2daily(time1, data1, tlim);
                [time3, data3] = data_daily2monthly(time2, data2, tlim); 
                [time, data] = data_monthly2annual(time3, data3, tlim);    
            otherwise
                stop(in_type, out_type)
        end
        
    case 'hourly'
        switch out_type
            case 'random'
                stop(in_type, out_type)
            case 'hourly'
                [time, data] = data_random2hourly(time0, data0, tlim, window);
            case 'daily'
                [time1, data1] = data_random2hourly(time0, data0, tlim, window);
                [time, data] = data_hourly2daily(time1, data1, tlim);
            case 'monthly'
                [time1, data1] = data_random2hourly(time0, data0, tlim, window);
                [time2, data2] = data_hourly2daily(time1, data1, tlim);
                [time, data] = data_daily2monthly(time2, data2, tlim);
            case 'seasonal'
                [time1, data1] = data_random2hourly(time0, data0, tlim, window);
                [time2, data2] = data_hourly2daily(time1, data1, tlim);
                [time3, data3] = data_daily2monthly(time2, data2, tlim); 
                [time, data] = data_monthly2seasonal(time3, data3, tlim); 
            case 'annual'
                [time1, data1] = data_random2hourly(time0, data0, tlim, window);
                [time2, data2] = data_hourly2daily(time1, data1, tlim);
                [time3, data3] = data_daily2monthly(time2, data2, tlim); 
                [time, data] = data_monthly2annual(time3, data3, tlim);     
            otherwise
                stop(in_type, out_type)
        end    
        
    case 'daily'
        switch out_type
            case 'random'
                stop(in_type, out_type)
            case 'hourly'
                stop(in_type, out_type)
            case 'daily'
                stop(in_type, out_type)
            case 'monthly'
                [time, data] = data_daily2monthly(time0, data0, tlim);
            case 'seasonal'
                [time1, data1] = data_daily2monthly(time0, data0, tlim); 
                [time, data] = data_monthly2seasonal(time1, data1, tlim); 
            case 'annual'
                [time1, data1] = data_daily2monthly(time0, data0, tlim); 
                [time, data] = data_monthly2annual(time1, data1, tlim);     
            otherwise
                stop(in_type, out_type)
        end   
        
    case 'monthly'
        switch out_type
            case 'random'
                stop(in_type, out_type)
            case 'hourly'
                stop(in_type, out_type)
            case 'daily'
                stop(in_type, out_type)
            case 'monthly'
                stop(in_type, out_type)
            case 'seasonal'
                [time, data] = data_monthly2seasonal(time0, data0, tlim); 
            case 'annual' 
                [time, data] = data_monthly2annual(time0, data0, tlim);     
            otherwise
                stop(in_type, out_type)    
        end     
        
end

end


function stop(in_type, out_type)
%     disp(['In type  : ' in_type])
%     disp(['Out type : ' out_type])
    error('Wrong out_type')
end