%==========================================================================
% Find the nesting cell ids based on nesting node ids
%
% input  :
%   fgrid    ---
%   nestnode --- nesting node ids
%
%                     -----------------------|
%                     ---------------------| |
%                                          | |
%                                          | | 
%                     |--------------------| |
%                     |----------------------|
%
% output :
%   nestcell --- nesting cell ids
%
% Siqi Li, SMAST
% 2022-10-25
%
% Updates:
%
%==========================================================================
function nestcell = f_find_nestcell(fgrid, nestnode)

pid = nestnode([1:end 1]);
px =fgrid.x(pid);
py =fgrid.y(pid);

nestcell = inpolygon(fgrid.xc, fgrid.yc, px, py);

