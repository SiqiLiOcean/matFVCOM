%==========================================================================
% matFVCOM package
% Convert time from America/New_York to GMT
%
% input  :
%   t_NY --- time in the TimeZone of America/New_York
% output :
%   t_GMT --- time in the GMT
%
% Siqi Li, SMAST
% 2024-06-11
%
% Updates:
%
%==========================================================================
function t_GMT = tconvert_NY2GMT(t_NY)

% Check if the time is during Daylight Saving Time
tf = isdst(t_NY);

% Daylight Saving Time
t_GMT(tf) = t_NY + 4/24;

% Standard Time
t_GMT(~tf) = t_NY + 5/24;




end