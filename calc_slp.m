%==========================================================================
% Calculate SLP based on perturbation potential temperature, water vapor
% mixing ratio, pressure and geopotential
% input  : (have the vertical dimension at the 3rd position)
%   --- T      : perturbation potential temperature (degree C)
%   --- QVAPOR : water vapor mixing ratio           (kg kg-1)
%   --- pres   : pressure                           (hPa)
%   --- gp     : geopotential                       (m2 s-2)
% 
% output :
%   --- slp    : sea level pressure                 (hPa)
% 
% Siqi Li, SMAST
% 2021-07-01
%
% Updates:
%
%==========================================================================
function slp = calc_slp(T, QVAPOR, pres, gp)

% dims_4 = size(T,1:4);
dims_4(1) = size(T,1);
dims_4(2) = size(T,2);
dims_4(3) = size(T,3);
dims_4(4) = size(T,4);



% Transform the 4-D matrix to 2-D, with the vertical dimension at the 2nd
% position
T = reshape(permute(T, [1 2 4 3]), [], dims_4(3));
QVAPOR = reshape(permute(QVAPOR, [1 2 4 3]), [], dims_4(3));
pres = reshape(permute(pres, [1 2 4 3]), [], dims_4(3));
gp = reshape(permute(gp, [1 2 4 3]), [], dims_4(3));
[n, nz] = size(T);


%-------------------Parameters-----------------------
G=9.81;         % gravity acceleration          (m s-2)
PCONST=100.;    % interpolation reference level (hPa)
GAMMA=0.0065;   % lapse rate                    (K m-1)
Rd=287.04;      % real gas constant for air     (m2 K-1 s-2)
  


traditional_comp=true;
TC=273.16+17.5;


%------------------Calculation-----------------------
% Calculate the height (m)
z = gp / G;

% Calculate the real temperature (K)
tk = calc_tc(T+300, pres) + 273.15;


%--------1.
% Find least zeta level that is PCONST Pa above the surface.  We later use this
% level to extrapolate a surface pressure and temperature, which is supposed
% to reduce the effect of the diurnal heating cycle in the pressure field.
level = sum(repmat(pres(:,1), 1, nz)-pres<=PCONST, 2) + 1;
% for j=1:south_north_dim
%     for i=1:west_east_dim
% 
%         level(i,j)=-1;
%         k=1;
%         found=false;
% 
%         while(~found && k<=bottom_top_dim)
%             if (p_tmp(i,j,k) < p_tmp(i,j,1)-PCONST)
%                 level(i,j)=k;
%                 found=true;
%             end
%             k=k+1;
%         end
% 
%         if (level(i,j)==-1)
%             disp('----error 1')
%         end
%     end
% end

%------2.
% Get temperature PCONST Pa above surface.  Use this to extrapolate
% the temperature at the surface and down to sea level.
k1 = max(level-1,1);
k2 = min(k1+1, nz-1);
if any(k1(:)==k2(:))
    error('Error 2')
end

ij1 = sub2ind([n nz], (1:n)',k1);
ij2 = sub2ind([n nz], (1:n)',k2);

p1 = pres(ij1);
p2 = pres(ij2);
t1 = tk(ij1) .* (1 + 0.608*QVAPOR(ij1));
t2 = tk(ij2) .* (1 + 0.608*QVAPOR(ij2));
z1 = z(ij1);
z2 = z(ij2);

p_pconst = pres(:,1) - PCONST;
t_pconst = t2 - (t2-t1) .* log(p_pconst./p2) .* log(p1./p2);
z_pconst = z2 - (z2-z1) .* log(p_pconst./p2) .* log(p1./p2);

t_sfc = t_pconst .* (pres(:,1)./p_pconst) .^ (GAMMA*Rd/G);
t_sl = t_pconst + GAMMA*z_pconst;

% for j=1:south_north_dim
%     for i=1:west_east_dim
% 
%         klo=max(level(i,j)-1,1);
%         khi=min(klo+1,bottom_top_dim-1);
% 
%         if (klo==khi)
%             disp('------error 2')
%         end
% 
%         plo=p_tmp(i,j,klo);
%         phi=p_tmp(i,j,khi);
%         tlo=temp(i,j,klo)*(1.+0.608*qv(i,j,klo));
%         thi=temp(i,j,khi)*(1.+0.608*qv(i,j,khi));
%         zlo=z(i,j,klo);
%         zhi=z(i,j,khi);
%         
%         p_at_pconst=p_tmp(i,j,1)-PCONST;
%         t_at_pconst=thi-(thi-tlo)*log(p_at_pconst/phi)*log(plo/phi);
%         z_at_pconst=zhi-(zhi-zlo)*log(p_at_pconst/phi)*log(plo/phi);
% 
%         t_surf(i,j)=t_at_pconst*(p_tmp(i,j,1)/p_at_pconst)^(GAMMA*Rd/G);
%         t_sea_level(i,j)=t_at_pconst+GAMMA*z_at_pconst;
%     end
% end


%----------3.
% If we follow a traditional computation, there is a correction to the sea level
% temperature if both the surface and sea level temperatures are *too* hot.
if (traditional_comp)
    l = t_sl>=TC & t_sfc<=TC;
    t_sl = TC - 0.005 * (t_sfc-TC).^2;
    t_sl(l) = TC;
end

% if (traditional_comp)
%     for j=1:south_north_dim
%         for i=1:west_east_dim
%             l1=t_sea_level(i,j)<TC;
%             l2=t_surf(i,j)<=TC;
%             l3=~l1;
%             if (l2 && l3) 
%                 t_sea_level(i,j)=TC;
%             else
%                 t_sea_level(i,j)=TC-0.005*(t_surf(i,j)-TC)^2;
%             end
%         end
%     end
% end

%--------4.
% Calculate the sea level pressure (hPa)
slp = pres(:,1) .* exp(2*G*z(:,1) ./ (Rd*(t_sl+t_sfc)));

% for j=1:south_north_dim
%     for i=1:west_east_dim
%         z_half_lowest=z(i,j,1);
%         slp(i,j)=p_tmp(i,j,1)*exp(();
%         slp(i,j)=slp(i,j)/100.;
%     end
% end


% Transform the 2-D matrix back to 3-D matrix
% (not back to 4-D matrix, because the vertical dimension has disappeared.)
slp = reshape(slp, dims_4([1 2 4]));
