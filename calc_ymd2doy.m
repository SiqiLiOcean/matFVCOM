%==========================================================================
% Convert datenum to day of year (starting from 1)
% e.g. 2003-01-03 12:00  --->  3.5
%
% input  :
%   There are 3 formats of input
%     - calc_ymd2doy(datenum(2012,1,3,12,0,0))
%     - calc_ymd2doy(2012,1,3,12,0,0)
%     - calc_ymd2doy('2012-01-03 12:00')
% output :
%   doy --- day of year 
% Siqi Li, SMAST
% 2021-09-30
%
% Updates:
%
%==========================================================================
function doy = calc_ymd2doy(varargin)

datenum_in = datenum(varargin{:});


datevec_in = datevec(datenum_in);

doy = datenum_in - datenum(datevec_in(1),1,1,0,0,0) + 1;

