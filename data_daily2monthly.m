%==========================================================================
% Calculate the monthly mean data
% 
% Input  : --- time0, the input daily time (MATLAB time format)
%          --- data0, the input daily data
%          --- varargin, time limits
%
% Output : --- time, the output monthly time (MATLAB time format)
%          --- data, the output monthly mean data
% 
% Usage  : [time, data] = data_daily2monthly(time0, data0);
%
% v1.0
%
% Siqi Li
% 2021-05-26
%
% Updates:
%
%==========================================================================
function [time, data] = data_daily2monthly(time0, data0, varargin)

% time0 = dayt;
% data0 = data2;

tlim = [];
if ~isempty(varargin)
    tlim = varargin{1};
    if sum(tlim<3000)==2
        tlim(1) = datenum(tlim(1), 1, 1);
        tlim(2) = datenum(tlim(2), 12, 1);
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
tvec0 = [tvec1(1) tvec1(2)   1 0 0 0];
tvec3 = [tvec2(1) tvec2(2)+1 1 0 0 0];



it1 = datenum(tvec0);
ii = 1;
while it1 < datenum(tvec3)
    
    it1_vec = datevec(it1);
    it1_vec(2) = it1_vec(2) + 1;
    it2 = datenum(it1_vec);
    k = find(time0>=it1 & time0<it2);
    
    time(ii,1) = it1;
    data(ii,1) = nanmean(data0(k));
    
    it1 = it2;
    ii = ii + 1;
    
end


% if ~isempty(tlim)
%     k = find(time>=tlim(1) & time<=tlim(2));
%     time = time(k);
%     data = data(k);
% end