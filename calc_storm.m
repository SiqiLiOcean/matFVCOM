%==========================================================================
% Calculate storm based on wind stress
%
%   Butman, B., Sherwood, C.R. and Dalyander, P.S., 2008. Northeast storms 
%   ranked by wind stress and wave-generated bottom stress observed in 
%   Massachusetts Bay, 1990–2006. Continental Shelf Research, 28(10-11), 
%   pp.1231-1245.
%
% input  :
%   time    --- hourly time in size of (1, nt)       (datenum)
%   wstress --- wind stress in size of (n, nt)       (Pa)
% 
% output :
%   storm
%      --- duration : storm duration (h)
%      --- IWINDS   : integrated wind stress (Pa h)
%      --- Time1    : starting time (yyyy-mm-dd HH:MM)
%      --- Time2    : ending time (yyyy-mm-dd HH:MM)
%      --- t1       : starting time (datenum)
%      --- t2       : ending time (datenum)
%      --- wstress
%
% Siqi Li, SMAST
% 2022-12-29
%
% Updates:
%
%==========================================================================
function storm = calc_storm(time, wstress, varargin)

varargin = read_varargin(varargin, {'Threshold'}, {0.2});

% Threshold = 0.2;
% wstress = [wstress; wstress; wstress];

time = time(:)';
nt = size(wstress, 2);
wstress = reshape(wstress, [], nt);
n = size(wstress, 1);


flag = wstress >= Threshold;
tflag1 = movsum(flag,[0 5], 2)==6;
tflag2 = movsum(flag,[0 11], 2)==1 & flag==1;

is_storm = zeros(n, nt);
for i = 1 : n
    flag_storm = 0;
    for it = 1 : nt
        if flag_storm==0
            if tflag1(i,it)
                k1 = it;
                flag_storm = 1;
            else
                continue
            end
        else
            if tflag2(i,it) || it==nt
                k2 = it;
                flag_storm = 0;
                is_storm(i, k1:k2) = 1;
            end
        end
    end
end
is_storm = any(is_storm, 1);

k1 = find(diff(is_storm) == 1) + 1;
k2 = find(diff(is_storm) == -1);
if is_storm(1)
    k1 = [1 k1];
end
if is_storm(end)
    k2 = [k2 nt];
end



for i = 1 : length(k1)
    ik = k1(i) : k2(i);
    duration = length(ik);
    data = wstress(:,ik);
    data_max = max(data, [], 1);
    largest = sort(data_max, 'descend');
    largest = largest(1:3);
    IWINDS = mean(data_max, 'omitnan') * duration;
    storm(i).Time1 = datestr(time(k1(i)), 'yyyy-mm-dd HH:MM');    
    storm(i).duration = duration;              % h
    storm(i).IWINDS = IWINDS;        % Pa h
    storm(i).wstress_mean = mean(data_max, 'omitnan');
    storm(i).wstress_max = mean(largest, 'omitnan');
    storm(i).Time2 = datestr(time(k2(i)), 'yyyy-mm-dd HH:MM');
    storm(i).t1 = time(k1(i));
    storm(i).t2 = time(k2(i));
%     storm(i).wstress = data;
end

