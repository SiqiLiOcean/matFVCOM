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
% 2023-06-28  Siqi Li  Allowed to read nesting NetCDF
%==========================================================================
function time = f_load_time(fnc, varargin)

varargin = read_varargin2(varargin, {'MJD'});

if any(contains({ncinfo(fnc).Variables.Name}, 'Times'))
    Times = ncread(fnc, 'Times')';

    delimiter = Times(1,11);
    time = datenum(Times, ['yyyy-mm-dd' delimiter 'HH:MM:SS.000000']);
else
    Itime = double(ncread(fnc, 'Itime'));
    Itime2 = double(ncread(fnc, 'Itime2'));
    time = Itime + Itime2/1000/3600/24;
    if contains(ncreadatt(fnc, 'Itime', 'format'), 'MJD')
        time = time + datenum(1858,11,17);
    end
end