%==========================================================================
% 3-D Interpolation
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% 2022-09-28
%
% Updates:
% 2022-10-03  Siqi Li  Added more methods for horizontal interpolation
%==========================================================================
function var2 = interp_3d(var1, depth1, std, depth2, method, varargin)

n1 = length(varargin{1});    
n2 = length(varargin{4});    


varargin = read_varargin(varargin, {'List1'}, {1:n1});
varargin = read_varargin(varargin, {'List2'}, {1:n2});


weight = interp_3d_calc_weight(depth1, std, depth2, method, varargin{:});
var2 = interp_3d_via_weight(var1, weight, 'List1', List1, 'List2', List2);


% if length(size(var1))~=2
%     error('The dimension number of input var1 is wrong')
% end
% 
% [k1, k2] = size(var1);
% 
% if k1==fgrid1.node && k2==fgrid1.kbm1
%     x1 = fgrid1.x;
%     y1 = fgrid1.y;
%     x2 = fgrid2.x;
%     y2 = fgrid2.y;
%     n1 = fgrid1.node;
%     n2 = fgrid2.node;
%     depth1 = fgrid1.deplay;
%     depth2 = fgrid2.deplay;
% elseif k1==fgrid1.node && k2==fgrid1.kb
%     x1 = fgrid1.x;
%     y1 = fgrid1.y;
%     x2 = fgrid2.x;
%     y2 = fgrid2.y;
%     n1 = fgrid1.node;
%     n2 = fgrid2.node;
%     depth1 = fgrid1.deplev;
%     depth2 = fgrid2.deplev;
% elseif k1==fgrid1.nele && k2==fgrid1.kbm1
%     x1 = fgrid1.xc;
%     y1 = fgrid1.yc;
%     x2 = fgrid2.xc;
%     y2 = fgrid2.yc;
%     n1 = fgrid1.nele;
%     n2 = fgrid2.nele;
%     depth1 = fgrid1.deplayc;
%     depth2 = fgrid2.deplayc;
% elseif k1==fgrid1.nele && k2==fgrid1.kb
%     x1 = fgrid1.xc;
%     y1 = fgrid1.yc;
%     x2 = fgrid2.xc;
%     y2 = fgrid2.yc;
%     n1 = fgrid1.node;
%     n2 = fgrid2.node;
%     depth1 = fgrid1.deplevc;
%     depth2 = fgrid2.deplevc;
% else
%     error('The size of input var1 is wrong.')
% end
% 
% % 2d horizontal interpolation from fgrid1 to fgrid2
% var_std = interp_vertical(depth1, var1, repmat(std,n1,1));
% 
% % vertical interpolation from fgrid1 sigma to standard depth 
% var_std_hori = interp_horizontal(x1, y1, var_std, x2, y2);
% 
% % vertical interpolation from standard depth to fgrid2 sigma
% var2 = interp_vertical(repmat(std,n2,1), var_std_hori, depth2);
