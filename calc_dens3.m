%==========================================================================
% To calculate the density from salinity, temperature and depth.   
%
% Ref:  Minimal Adjustment of Hydrographic Profiles to Achieve Static
%         Stability. (Jackett and McDougall, 1995)		(Equation A1)
%
% input  : S       salinity               (ipss-78)
%          PT      potential temperature  degree Celsius
%          D       depth                  m
%
% output : rho     density                kg/m3
%
% Siqi Li, SMAST
% 2021-06-18
%
% Updates:
%
%==========================================================================
function rho = calc_dens3(S, PT, D)

% Make sure the water depth is positive
if any(D(:)<0)
    error('D should be positive for depth.')
end

% Pr = 0.;              % dbar
g = 9.81;             % m/s2
rho0 = 1025;          % kg/m3

RZU = rho0 * g * D;   % Pa
P = RZU / 1e5;      % ---> bar (1 bar = 1e5 Pa)

% PT = calc_theta(S, T, RZU, Pr);


%-------------When there is no pressure------------------------------------
% (Same as that in calc_dens1.m)
T = PT;
Tp2 = T.^2;
Tp3 = T.^3;
Tp4 = T.^4;
Tp5 = T.^5;

A =  8.24493e-1 - 4.0899e-3*T + 7.6438e-5*Tp2 - 8.2467e-7*Tp3 + 5.3875e-9*Tp4;
B = -5.72466e-3 + 1.0227e-4*T - 1.6546e-6*Tp2;
C =  4.8314e-4;

rho0 = 999.842594 + 6.793952e-2*T -9.095290e-3*Tp2 + 1.001685e-4*Tp3 - 1.120083e-6*Tp4 + 6.536336e-9*Tp5;

rho0 = rho0 + A.*S + B.*S.^1.5 +  C.*S.^2;

%----Compute secant bulk modulus-------------------------------------------
Pp2 = P.^2;
Sp15 = S.^1.5;

H =  1.965933e+4 + 1.444304e-2*T - 1.706103e00*Tp2 + 9.648704e-3*Tp3 - 4.190253e-5*Tp4;
I =  5.284855e+1 - 3.101089e-1*T + 6.283263e-3*Tp2 - 5.084188e-5*Tp3;
J =  3.886640e-1 + 9.085835e-3*T - 4.619924e-4*Tp2;
K =  3.186519e00 + 2.212276e-2*T - 2.984642e-4*Tp2 + 1.956415e-6*Tp3;
L =  6.704388e-3 - 1.847318e-4*T + 2.059331e-7*Tp2;
M =  1.480266e-4;
N =  2.102898e-4 - 1.202016e-5*T + 1.394680e-7*Tp2;
O = -2.040237e-6 + 6.128773e-8*T + 6.207323e-10*Tp2;

bulk = H + I.*S + J.*Sp15 + K.*P + L.*P.*S + M*P.*Sp15 + N.*Pp2 + O.*Pp2.*S;

rho = rho0 ./ (1 - P./bulk);

