%==========================================================================
% Interpolate FVCOM 3d data to scatted points.
%
% input  :
%   fgrid --- fvcom grid
%   time0 --- source data time (nt0)
%   var0  --- data on fvcom grid (the 1st dimension should be node/nele)
%   xo    --- destination x (1)
%   yo    --- destination y (1)
%   t0    --- destination time (nt)
% 
% output :
%   var_out --- data interpolated on destination point (nz, nt) or (nz) or (nt)
%
% Siqi Li, SMAST
% 2022-11-07
%
% Updates:
%
%==========================================================================
function var_out = f_interp_xyt(fgrid, time0, var0, xo, yo, to)

disp('Be careful! You would better include the vertical interpolation.')

var1 = f_interp_xy(fgrid, var0, xo, yo);

var_out = f_interp_t(time0, var1, to);
