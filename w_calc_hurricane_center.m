%==========================================================================
% Calculate the hurricane center from SLP
%
% input  : 
%   --- w
%   --- slp0 : sea level pressure (nx, ny, nt) unit: hPa
%
% output :
%   --- clon :
%   --- clat :
%   --- cslp :
%
% Siqi Li, SMAST
% 2021-07-01
%
% Updates:
%
%==========================================================================
function [clon, clat, slp] = w_calc_hurricane_center(w, slp0)


nt = size(slp0, 3);


x = w.x;
y = w.y;


for it = 1 :nt
    slp_slice = slp0(:,:,it);
    [slp(it), ij] = nanmin(slp_slice(:));
    clon(it) = x(ij);
    clat(it) = y(ij);
end


% [xlims, ylims] = w_2d_range(w);
% xl = linspace(xlims(1), xlims(2), 400);
% yl = linspace(ylims(1), ylims(2), 400);
% 
% [yy, xx] = meshgrid(yl, xl);
% 
% for it = 1 : nt
%     disp([num2str(it) '/' num2str(nt)])
%     slp_it = slp0(:,:,it);
%     F = scatteredInterpolant(x(:), y(:), slp_it(:));
%     slp_slice = F(xx, yy);
%     [slp(it), ij] = nanmin(slp_slice(:));
%     clon(it) = xx(ij);
%     clat(it) = yy(ij);
% end
    
% nx = w.nx;
% ny = w.ny;
% [JJ, II] = meshgrid(1:ny, 1:nx);
% 
% il = linspace(1, nx, 400);
% jl = linspace(1, ny, 400);
% [jj, ii] = meshgrid(jl, il);
% 
% F_lon = scatteredInterpolant(II(:), JJ(:), x(:));
% F_lat = scatteredInterpolant(II(:), JJ(:), y(:));
% 
% 
% for it = 1 : nt
%     slp = griddata(II, JJ, slp0(:,:,it), ii, jj);
%     ij = find(slp==nanmin(slp(:)));
%     clon(it) = F_lon(ii(ij), jj(ij));
%     clat(it) = F_lat(ii(ij), jj(ij));
% end