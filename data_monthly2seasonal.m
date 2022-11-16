%==========================================================================
% Calculate the seasonal mean data
% 
% Input  : --- time0, the input monthly time (MATLAB time format)
%          --- data0, the input monthly data
%          --- varargin, time limits
%
% Output : --- time, the output seasonal time (MATLAB time format)
%          --- data, the output seasonal mean data (winter, spring, summer, 
%                autumn)
% 
% Usage  : [year, data] = data_monthly2seasonal(time0, data0);
%
% v1.0
%
% Siqi Li
% 2021-05-26
%
% Updates:
%
%==========================================================================
function [time, data] = data_monthly2seasonal(time0, data0, varargin)

% time0 = montht;
% data0 = data3;


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
tvec0 = [tvec1(1)-1 12 1 0 0 0];
tvec3 = [tvec2(1)   12 1 0 0 0];



it1 = datenum(tvec0);
ii = 1;
while it1 < datenum(tvec3)
    
    it1_vec = datevec(it1);
    it1_vec(2) = it1_vec(2) + 3;
    it2 = datenum(it1_vec);
    k = find(time0>=it1 & time0<it2);
    
    time1(ii,1) = it1;
    data1(ii,1) = nanmean(data0(k));
    
    it1 = it2;
    ii = ii + 1;
    
end

time = reshape(time1, 4, [])';
data = reshape(data1, 4, [])';


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
% % % 
% % % if tvec1(2)==12
% % %     year1 = tvec1(1) + 1;
% % % else
% % %     year1 = tvec1(1);
% % % end
% % % if tvec2(2) == 12
% % %     year2 = tvec2(1) + 1;
% % % else
% % %     year2 = tvec2(1);
% % % end
% % % 
% % % 
% % % year = (year1 : year2)';
% % % 
% % % n1 = mod(tvec1(2), 12); 
% % % n2 = 11-mod(tvec2(2),12);
% % % 
% % % data0 = [nan(n1,1); data0(:); nan(n2,1)];
% % % data0 = reshape(data0, 3, [])';
% % % 
% % % day_of_month = (datenum(year1-1, 13:length(data0(:))+12, 1) - datenum(year1-1, 12:length(data0(:))+11, 1))';
% % % day_of_month = reshape(day_of_month, 3, [])';
% % % % flag = ~isnan(data0);
% % % day_of_month(isnan(data0)) = nan;
% % % weight = day_of_month ./ repmat(nansum(day_of_month,2), 1, 3);
% % % data0 = data0 .* weight;
% % % data = reshape(nansum(data0, 2), 4, [])';
% % % flag = reshape(sum(isnan(data0), 2), 4, [])';
% % % data(flag==3) = nan;
% % % 
% % % % data = reshape(nanmean(data0, 2), 4, [])';
% % % 
% % % time = datenum(year, 1, 1);
% % % 
% % % if ~isempty(tlim)
% % %     k = find(time>=tlim(1) & time<=tlim(2));
% % %     time = time(k);
% % %     data = data(k,:);
% % % end
