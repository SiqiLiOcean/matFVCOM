%==========================================================================
% matFVCOM package
% Convert time from GMT to America/New_York 
%
% input  :
%   t_GMT --- time in the GMT
% output :
%   t_NY --- time in the TimeZone of America/New_York
%
% Siqi Li, SMAST
% 2024-06-11
%
% Updates:
%
%==========================================================================
function t_NY = tconvert_GMT2NY(t_GMT)

% Check if the time is during Daylight Saving Time
tf = isdst(datetime(t_GMT, 'ConvertFrom', 'datenum'));

% Daylight Saving Time
t_NY(tf) = t_GMT - 4/24;

% Standard Time
t_NY(~tf) = t_GMT - 5/24;


end