%==========================================================================
% Calculate heat flux via COARE30 using WRF output.
%
% input  :
% 
%     u = relative wind speed (m/s) at height zu(m)
%     t = bulk air temperature (degC) at height zt(m)
%    rh = relative humidity (%) at height zq(m)
%     P = surface air pressure (mb) (default = 1015)
%    ts = water temperature (degC)
%    Rs = downward shortwave radiation (W/m^2) (default = 150) 
%    Rl = downward longwave radiation (W/m^2) (default = 370)
%   lat = latitude (default = +45 N)
%    zi = PBL height (m) (default = 600m)
%
% output : 
%  B contains five heat flux variables, all of which are negative
%          when OCEAN loses heat. (W/m^2)
%    net      --- net heat flux
%    short    --- short wave radiation
%    long     --- long wave radiation
%    sensible --- sensible heat flux
%    latent   --- latent heat flux
%  C contains three variables, which are:
%    usr      --- ustar/friction velocity (m/s)
%    tau      --- wind stress (N/m^2)
%    Cd       --- wind stress transfer coefficient at height zu   
%
% Siqi Li, SMAST
% 2021-09-15
%
% Updates:
%
%==========================================================================
function [B, C] = calc_coare30(u,zu,t,zt,rh,zq,P,ts,Rs,Rl,lat,zi)


sigma = 5.6697e-8;  % Stefan–Boltzmann constant


dims = size(u);

if length(zu)==1
    zu = ones(dims) * zu;
end
if length(zt)==1
    zt = ones(dims) * zt;
end
if length(zq)==1
    zq = ones(dims) * zq;
end
if length(zi)==1
    zi = ones(dims) * zi;
end

A = coare30vn_ref_cool(u,zu,t,zt,rh,zq,P,ts,Rs,Rl,lat,zi,10,10,10);

sensible = reshape(A(:,3), dims);
latent = reshape(A(:,4), dims);
short = Rs;
long = Rl - 0.98 * sigma * (ts+273.15).^4;  % Stefan–Boltzmann Law
net = short + long + sensible + latent;

B.net = net;
B.short = short;
B.long = long;
B.sensible = sensible;
B.latent = latent;
% B = [net(:) short(:) long(:) sensible(:) latent(:)];

C.usr = A(:,1);
C.tau = A(:,2);
C.Cd = A(:,12);