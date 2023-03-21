%==========================================================================
% matFVCOM package
%   Read time from FVCOM NetCDF files
%
% input  :
%   fnc --- FVCOM NetCDF files containing 'Times'
%
% output :
%   time --- time in datenum format
%
% Siqi Li, SMAST
% 2023-03-08
%
% Updates:
%
%==========================================================================
function time = f_load_time(fnc)

Times = ncread(fnc, 'Times')';

delimiter = Times(1,11);
time = datenum(Times, ['yyyy-mm-dd' delimiter 'HH:MM:SS.000000']);
