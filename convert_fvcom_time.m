%==========================================================================
% Convert MATLAB time to FVCOM time
%
% input  :
%   time0 --- MATLAB time
% 
% output :
%   time  --- MJD (real) or days from 0 (ideal)
%   Itime --- integer parts of time (day)
%   Itime2--- digital parts of time (msec)
%   Times --- Date string (yyyy-mm-dd HH:MM:SS.000000)
%
% Siqi Li, SMAST
% 2022-10-25
%
% Updates:
%
%==========================================================================
function [time, Itime, Itime2, Times] = convert_fvcom_time(time0, varargin)

read_varargin2(varargin, {'Ideal'});

if isempty(Ideal)       % Real case
    mjd = datenum(1858, 11, 17);
else                    % Ideal case
    mjd = 0;
end

time = time0 - mjd;
Itime = floor(time);
Itime2 = (time - Itime) * 24 * 3600 * 1000;     % in msec
Times = datestr(time0, 'yyyy-mm-dd HH:MM:SS.000000');

