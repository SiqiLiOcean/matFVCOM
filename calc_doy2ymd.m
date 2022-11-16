%==========================================================================
% Convert day of year (starting from 1) to datenum
% e.g.  3.5 --->  2003-01-03 12:00
%
% input  :
%   year --- e.g. 2012
%   doy  --- day of year 
% output :
%   datenum_out --- 
% 
% Siqi Li, SMAST
% 2021-09-30
%
% Updates:
%
%==========================================================================
function datenum_out = calc_doy2ymd(year, doy)



datenum_out = datenum(year, 1, 1, 0, 0, 0) - 1 + doy;
