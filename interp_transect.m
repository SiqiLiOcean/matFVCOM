%==========================================================================
% Interpolation for transect plot
%
% Input  : x_in (n_in)
%          y_in (n_in)
%          z_in (n_in,nsigma_in),  positive for water
%          var_in (n_in,nsigma_in)
%          x (n_out)
%          y (n_out)
%          (Optional)
%          zlims (2) [min(depth) max(depth)], for figure (negative for
%          water)
%
% Output : dd (n_out,nz_out)
%          zz (n_out,nz_out)
%          var_out(n_out,nz_out)
%          x_sec (n_out)
%          y_sec (n_out)
%
% Note : The depth1 and depth2 are all positive, and should be increasing.
%
% Siqi Li, SMAST
% 2020-03-17
%
% Updates:
% 2020-03-18  Siqi Li, Inputs of all the weight related function were 
%                      adjusted. 
%                      func_horizontal_interp_calc_weight_node was removed.
% 2021-06-10  Siqi Li, Added the outputs of x_sec and y_sec
%==========================================================================
% function [dd, zz, var2, x_sec, y_sec] = interp_transect(x1, y1, z1, var1, x2, y2, varargin)
function [dd, zz, var2, x_sec, y_sec] = interp_transect(METHOD_2D, var1, varargin)

[dd, zz, weight, x_sec, y_sec] = interp_transect_calc_weight(METHOD_2D, varargin{:});

var2 = interp_transect_via_weight(var1, weight);

% % npixel = 200;
% % zlim = [];
% % 
% % i = 1;
% % while i< length(varargin)
% %     switch lower(varargin{i})
% %         case 'npixel'
% %             npixel = varargin{i+1};
% %         case 'zlim'
% %             zlim = varargin{i+1};
% %     end
% %     i = i + 2;
% % end
% varargin = read_varargin(varargin, {'npixel', 'zlims'}, {200, []});
% 
% % Dimensions
% n1=length(x1);
% % nele_in=size(nv_in,1);
% % nsigma_in=size(z1,2);
% 
% % [x_sec,y_sec,d_sec,z_sec] = interp_transect_pixel(x2,y2,-zlims);
% [x_sec, y_sec, d_sec] = interp_transect_pixel_horizontal(x2, y2, 'npixel', npixel);
% % ====================Generate horizontal weights ====================
% % weight_h=interp_horizontal_calc_weight(x1,y1,x_sec,y_sec);
% weight_h = interp_2d_calc_weight('TRI', )
% 
% if isempty(zlims)
% %     iz = find(z1(1,:)==min(z1(1,:));
%     %--- interp bottom depth
% %     z_bot = interp_horizontal_via_weight(z1(:,end), weight_h);
%     
%     zlims = [min(z1(:)) max(z1(:))];
% end
% 
% z_sec = interp_transect_pixel_vertical(zlims, 'npixel', npixel);
% 
% % ====================Vertical Interpolation to STD====================
% % var_std=interp_vertical(z1,var1,repmat(z_sec,n1,1));
% var_std=interp_vertical(z1,var1,repmat(z_sec,n1,1),'list',unique(weight_h.id));
% 
% % ====================Horizontal Interpolation====================
% var2=interp_horizontal_via_weight(var_std,weight_h);
% 
% 
% % ====================Generate the transect grid====================
% % [dd,hh]=meshgrid(d_sec,-h_sec);
% [zz,dd]=meshgrid(z_sec, d_sec);

