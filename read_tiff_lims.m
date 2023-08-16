%==========================================================================
% Read tiff file to get xlims and ylims
%
% input  : 
%   fin --- tiff input file.
% 
% output :
%   xlims --- x lims
%   ylims --- y limits
%
% Siqi Li, SMAST
% 2023-07-24
%
% Updates:
%
%==========================================================================
function [xlims, ylims] = read_tiff_lims(fin, varargin)



% Read the tiff file
[~,R] = readgeoraster(fin);

% Read the dimension information
% disp(R.CoordinateSystemType)
switch R.CoordinateSystemType
    case 'geographic'
        xlims = R.LongitudeLimits;
        ylims = R.LatitudeLimits;
    case 'planar'
        xlims = R.XWorldLimits;
        ylims = R.YWorldLimits;
    otherwise
        error(['Unknown CoordinateSystemType: ' R.CoordinateSystemType])
end

xlims = [min(xlims) max(xlims)];
ylims = [min(ylims) max(ylims)];
