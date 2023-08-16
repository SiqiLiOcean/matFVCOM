%==========================================================================
% Fill the NaN with the nearest points
%
% input  :
%   fgrid ---
%   var1  ---
%   type  --- 'linear', 'nearest', or 'dye'
% 
% output :
%   var2  ---
%
% Siqi Li, SMAST
% 2023-01-03
%
% Updates:
%
%==========================================================================
% function [var2, dist] = f_fill_missing(fgrid, var1, type)
function var2 = f_fill_missing(fgrid, var1, type)

n = size(var1, 1);
switch n
    case fgrid.node
        x = fgrid.x;
        y = fgrid.y;
        around = fgrid.nbsn;
    case fgrid.nele
        x = fgrid.xc;
        y = fgrid.yc;
        around = fgrid.nbe;
    otherwise
        error('The input data is in wrong size.')
end

nz = size(var1, 2);
nt = size(var1, 3);
var2 = var1;

switch lower(type) 
    case 'dye'
        
        for it = 1 : nt
            for iz = 1 : nz
                disp(['---Layer ' num2str(iz, '%2.2d') '; Time ' num2str(it, '%5.5d')])
                while any(isnan(var2(:,iz,it)))
                    var = [var2(:,iz,it); nan];
                    i_nan = find(isnan(var(1:n)));
%                     i_num = find(~isnan(var(1:n-1, iz, it)));
                    var(i_nan) = mean(var(around(i_nan,:)), 2, 'omitnan');
                    var2(:,iz,it) = var(1:n);
                end
            end
        end

    case {'linear', 'nearest'}

        for it = 1 : nt
            for iz = 1 : nz
                i_nan = find(isnan(var1(:, iz, it)));
                i_num = find(~isnan(var1(:, iz, it)));

                F = scatteredInterpolant(x(i_num), y(i_num), var1(i_num,iz,it), 'linear', type);
                var2(i_nan,iz,it) = F(x(i_nan), y(i_nan));
            end
        end

    otherwise
        error('Unknown type.')

end

% % n = size(var1, 1);
% % 
% % switch n
% %     case fgrid.node
% %         x = fgrid.x;
% %         y = fgrid.y;
% %     case fgrid.nele
% %         x = fgrid.xc;
% %         y = fgrid.yc;
% %     otherwise
% %         error('Wrong input size.')
% % end
% % 
% % i_nan = find(isnan(var1(:,1)));
% % i_num = find(~isnan(var1(:,1)));
% % 
% % 
% % % k = ksearch([x(i_nan) y(i_nan)], [x(i_num) y(i_num)]);
% % [k, d] = ksearch([x(i_num) y(i_num)], [x(i_nan) y(i_nan)]);
% % 
% % var2 = var1;
% % 
% % var2(i_nan,:) = var1(i_num(k),:);
% % dist = nan(n, 1);
% % dist(i_nan) = d;
