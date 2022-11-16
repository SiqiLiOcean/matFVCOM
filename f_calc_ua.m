%==========================================================================
% Calculate vertically averaged velocity of FVCOM currents
%
% input  :
%   fgrid   --- fvcom grid cell
%   u       --- y current
%   v       --- x current
%   'Order' --- 0 : nearest interpolation (same method as that in FVCOM)
%               1 : 1st order interpolation
% 
% output :
%
% Siqi Li, SMAST
% 2021-10-20
%
% Updates:
%
%==========================================================================
function [ua, va] = f_calc_ua(fgrid, u, v, varargin)

% varargin = read_varargin(varargin, {'Order'}, {1});


siglevc = fgrid.siglevc;
kbm1 = fgrid.kbm1;

dz_levc = siglevc(:, 1:end-1) - siglevc(:, 2:end);


for it = 1 : size(u, 3)
    
%     switch Order
%         case 0
            ua(:,it) = sum(u(:,:,it) .* dz_levc, 2);
            va(:,it) = sum(v(:,:,it) .* dz_levc, 2);
%         case 1
%             z_mat(:,1) = dz_levc(:,1) + 0.5 * (dz_levc(:,1) + dz_levc(:,2));
%             for iz = 2 : kbm1-1
%                 z_mat(:,iz) = dz_levc(:,iz) + 0.5 * (dz_levc(:,iz-1) + dz_levc(:,iz+1));
%             end
%             z_mat(:,kbm1) = dz_levc(:,kbm1) + 0.5 * (dz_levc(:,kbm1-1) + dz_levc(:,kbm1));
%             
%             z_mat = z_mat * 0.5;
%             ua(:,:,it) = sum(u(:,:,it) .* z_mat, 2);
%             va(:,:,it) = sum(v(:,:,it) .* z_mat, 2);
%     end
    
end