%==========================================================================
% Set the xlims and ylims, and set axes equal
%
% input  :
%   xlims : x axis range [x1 x2]
%   ylims : y axis range [y1 y2]
% 
% output :
%   \
%
% Siqi Li, SMAST
% 2023-09-25
%
% Updates:
%
%==========================================================================
function plane_range(xlims, ylims)

xlim(xlims);
ylim(ylims);

axis equal

xlim(xlims);
ylim(ylims);
