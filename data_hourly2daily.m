%==========================================================================
% Calculate the hourly mean data
% 
% Input  : --- time0, the input hourly time (MATLAB time format)
%          --- data0, the input hourly data
%          --- varargin, time limits
%
% Output : --- time, the output daily time (MATLAB time format)
%          --- data, the output daily mean data
% 
% Usage  : [time, data] = data_hourly2daily(time0, data0);
%
% v1.0
%
% Siqi Li
% 2021-05-26
%
% Updates:
%
%==========================================================================
function [time, data] = data_hourly2daily(time0, data0, varargin)

% time0 = hourt;
% data0 = data1;
% time0 = mod_hourly_time;
% data0 = mod_hourly_wspd;
% tlim = [2003 2017];
%         tlim(1) = datenum(tlim(1), 1, 1);
%         tlim(2) = datenum(tlim(2)+1, 1, 1) - 1/60/24;
        
% time0 = buoy.time;
% data0 = buoy.wspd;
% tlim = [2000 2002];


tlim = [];
if ~isempty(varargin)
    tlim = varargin{1};
    if sum(tlim<3000)==2
        tlim(1) = datenum(tlim(1), 1, 1);
        tlim(2) = datenum(tlim(2), 12, 31);
    end
end

t1 = time0(1);
t2 = time0(end);

if isempty(tlim)
    tvec1 = datevec(t1);
    tvec2 = datevec(t2);
else
    tvec1 = datevec(tlim(1));
    tvec2 = datevec(tlim(2));
end
tvec0 = [tvec1(1) tvec1(2) tvec1(3)   0 0 0];
tvec3 = [tvec2(1) tvec2(2) tvec2(3)+1 0 0 0];



it1 = datenum(tvec0);
ii = 1;
while it1 < datenum(tvec3)
    
    it1_vec = datevec(it1);
    it1_vec(3) = it1_vec(3) + 1;
    it2 = datenum(it1_vec);
    k = find(time0>=it1 & time0<it2);
    
    time(ii,1) = it1;
    data(ii,1) = nanmean(data0(k));
    
    it1 = it2;
    ii = ii + 1;
    
end


% % % 
% % % tlim = [];
% % % if ~isempty(varargin)
% % %     tlim = varargin{1};
% % %     if sum(tlim<3000)==2
% % %         tlim(1) = datenum(tlim(1), 1, 1);
% % %         tlim(2) = datenum(tlim(2)+1, 1, 1) - 1/24;
% % %     end
% % % end
% % % 
% % % t0 = floor(time0(1));
% % % t1 = time0(1);
% % % t2 = time0(end);
% % % t3 = ceil(time0(end)) - 1/24;
% % % 
% % % if ~isempty(tlim)
% % %     t0 = floor(tlim(1));
% % % %     t1 = time0(1);
% % % %     t2 = time0(end);
% % %     t3 = ceil(tlim(2)) - 1/24;
% % %     
% % %     k = find(t0-time0>1e-6);
% % %     time0(k) = [];
% % %     data0(k) = [];
% % %     t1 = time0(1);
% % %     k = find(time0-t3>1e-6);
% % %     time0(k) = [];
% % %     data0(k) = [];
% % %     t2 = time0(end);
% % %     
% % % end
% % % 
% % % 
% % % % tvec1 = datevec(t1);
% % % % tvec2 = datevec(t2);
% % % 
% % % gap1 = round((t1 - t0) * 24);
% % % gap2 = round((t3 - t2) * 24);
% % % 
% % % % data0 = [nan(tvec1(4),1); data0(:); nan(23-tvec2(4),1)];
% % % data0 = [nan(gap1,1); data0(:); nan(gap2,1)];
% % % 
% % % 
% % % data0 = reshape(data0, 24, [])';
% % % 
% % % 
% % % time = (t0 : t3)';
% % % data = nanmean(data0, 2);
% % % 
% % % % if ~isempty(tlim)
% % % %     k = find(time>=tlim(1) & time<=tlim(2));
% % % %     time = time(k);
% % % %     data = data(k);
% % % % end
