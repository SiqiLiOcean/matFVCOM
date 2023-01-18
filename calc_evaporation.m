%==========================================================================
% Calculate evaporation
% (Yu, 2007)
%
% input  :
%   latent --- latent heat flux (W/m2, positive for ocean gain energy) 
%   sst    --- sea surface temperautre (C)
%   Rho0   --- surface sea water density, default 1021 (kg/m3)
%
% output :
%   evap   --- evaporating rate (m/s, negative for ocean loses water)
%
% Siqi Li, SMAST
% 2023-01-04
%
% Updates:
%
%==========================================================================
function evap = calc_evaporation(latent, sst, varargin)

varargin = read_varargin(varargin, {'Rho0'}, {1021.});

evap = latent / Rho0 ./ ((2.501-0.00237*sst)*1e6);

