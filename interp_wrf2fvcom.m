%==========================================================================
% matFVCOM package
%   interp WRF-grid variables to FVCOM-grid ones 
%
% input  :
%   src
%   w
%   f
%   type
% 
% output :
%   weight
%
% Siqi Li, SMAST
% 2023-09-16
%
% Updates:
%
%==========================================================================
function dst = interp_wrf2fvcom(src, w, f, type, varargin)


weight = interp_wrf2fvcom_calc_weight(w, f, type);
dst = interp_wrf2fvcom_via_weight(src, weight);

