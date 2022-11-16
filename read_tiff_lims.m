%==========================================================================
% Read tiff file limits
%
% input  : 
%   fin --- tiff input file.
% 
% output :
%   xlims --- x/longitude limits
%   ylims --- y/latitude limits
%
% Siqi Li, SMAST
% 2022-10-20
%
% Updates:
%
%==========================================================================
function [xlims, ylims] = read_tiff_lims(ftiff)

 info = geotiffinfo(ftiff);

 BoundingBox = info.BoundingBox;

 xlims = BoundingBox(1:2, 1);
 ylims = BoundingBox(1:2, 2);
 