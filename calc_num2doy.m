%==========================================================================
% Convert datenum to day of year (starting from 1)
% e.g.  2003-01-03 12:00 ---> 3.5  
%
% input  :
%   year --- datenum_in
% output :
%   doy  --- day of year 
% 
% Siqi Li, SMAST
% 2023-01-30
%
% Updates:
%
%==========================================================================
function doy = calc_num2doy(datenum_in)

dvec = datevec(datenum_in);
doy = datenum_in - datenum(dvec(1), 1, 0);
