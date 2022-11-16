%==========================================================================
% Calculate the annual mean data
% 
% Input  : --- time0, the input monthly time (MATLAB time format)
%          --- data0, the input monthly data
%          --- varargin, time limits
%
% Output : --- time, the output annual time (MATLAB time format)
%          --- data, the output annual mean data
% 
% Usage  : [year, data] = data_monthly2annual(time0, data0);
%
% v1.0
%
% Siqi Li
% 2021-05-26
%
% Updates:
%
%==========================================================================
function [time, data] = data_monthly2annual(time0, data0, varargin)

% time0 = montht;
% data0 = data3;
% time0 = monthly_time;
% data0 = monthly_wspd;


tlim = [];
if ~isempty(varargin)
    tlim = varargin{1};
    if sum(tlim<3000)==2
        tlim(1) = datenum(tlim(1), 1, 1);
        tlim(2) = datenum(tlim(2), 1, 1);
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
tvec0 = [tvec1(1)   1 1 0 0 0];
tvec3 = [tvec2(1)+1 1 1 0 0 0];



it1 = datenum(tvec0);
ii = 1;
while it1 < datenum(tvec3)
    
    it1_vec = datevec(it1);
    it1_vec(1) = it1_vec(1) + 1;
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
% % %         tlim(2) = datenum(tlim(2)+1, 1, 1) - 1/60/60/24;
% % %     end
% % % end
% % % 
% % % % t = datevec(time0);
% % % % t = t(:, 1:2);
% % % t1 = time0(1);
% % % t2 = time0(end);
% % % 
% % % 
% % % tvec1 = datevec(t1);
% % % tvec2 = datevec(t2);
% % % 
% % % year1 = tvec1(1);
% % % year2 = tvec2(1);
% % % 
% % % 
% % % year = (year1 : year2)';
% % % 
% % % n1 = tvec1(2) - 1;
% % % n2 = 12 - tvec2(2);
% % % 
% % % 
% % % 
% % % data0 = [nan(n1,1); data0(:); nan(n2,1)];
% % % data0 = reshape(data0, 12, [])';
% % % 
% % % day_of_month = (datenum(year1, 2:length(data0(:))+1, 1) - datenum(year1, 1:length(data0(:)), 1))';
% % % day_of_month = reshape(day_of_month, 12, [])';
% % % % flag = ~isnan(data0);
% % % day_of_month(isnan(data0)) = nan;
% % % weight = day_of_month ./ repmat(nansum(day_of_month,2), 1, 12);
% % % data0 = data0 .* weight;
% % % data = nansum(data0, 2);
% % % flag = sum(isnan(data0), 2);
% % % data(flag==12) = nan;
% % % 
% % % time = datenum(year, 1, 1);
% % % 
% % % if ~isempty(tlim)
% % %     k = find(time>=tlim(1) & time<=tlim(2));
% % %     time = time(k);
% % %     data = data(k);
% % % end
