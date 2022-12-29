%==========================================================================
% Calculate the wind stress based on Large and Pond (1981)
%
% input  :
%   wspd --- wind speed (m/s)
%
% output :
%
% Siqi Li, SMAST
% 2022-12-29
%
% Updates:
%
%==========================================================================
function wstress = calc_wind_stress_LP1981(wspd, varargin)

varargin = read_varargin(varargin, {'rho'}, {1.29});

Wmin = 11;
Wmax = 25;
Cd = 0.001 * (0.49 + 0.065*max(min(wspd,Wmax), Wmin));


wstress = rho * Cd .* wspd .* wspd;
