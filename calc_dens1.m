%==========================================================================
% Calculate Potential Density Based on Potential Temp and Salinity        
% Pressure effects are incorported (Can Model Fresh Water < 4 Deg C)     
%
% Ref:  algorithms for computation of fundamental properties of          
% seawater , Fofonoff and Millard.		
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
function rho = calc_dens1(S, T, D)

Pr = 0.;              % dbar
g = 9.81;             % m/s2
rho0 = 1025;          % kg/m3

RZU = rho0 * g * D;   % Pa
RZU = RZU / 1e4;      % ---> dbar (1 dbar = 1e4 Pa) 


PT = calc_theta(S, T, RZU, Pr);
sigma = calc_sigma_millero(S, PT, RZU);

rho = sigma + 1000;

end
%==========================================================================
% Calculate density anomaly (and specific volume anomaly) based on 
% salinity, potential temperature and pressure. 
%
% Ref 1
% Millero and Poisson (1981), International one-atmosphere equation of state of
% seawater. Deep-Sea Research, Vol. 8A, No.6, 625-629
% (Equations on Page 625)
% Ref 2
% Millero et al. (1980), A new high pressure equation of state for
% seawater. Deep-Sea Research, Vol. 27A, 255-264
% (Equations on Page 263)
%
% input  : S0      salinity               (ipss-78)
%          T0      potential temperature  degree Celsius
%          P0      pressure               dbar
%
% output : sigma   density anomaly        kg/m3
%          sva     specific volume anomaly (removed)
%
%
% Check value 1 (from paper 1): rho=1027.67547 kg/m3
% Input: S0=35; T0=5 C; P0=0 dbar; 
% m = 100; kb = 50;
% S0 = 35 * ones(m,kb);
% T0 = 5 * ones(m,kb);                                      
% P0 = 0 * ones(m,kb);
%
% Check value 2 (from paper 2)
%   S0    T0    P0         K 
%    0     0  1000  22977.21 
%   35     0  1000  24992.00
%    0    25  1000  25405.10
%   35    25  1000  27108.95
% S0 = [ 0 35  0 35];
% T0 = [ 0  0 25 25];
% P0 = [1000 1000 1000 1000];
% 
% Check value 3 (from paper 2)
%   S0    T0    P0          rho   
%    0     5     0    999.96675 
%    0    25     0    997.04796
%   35     5     0   1027.67547
%   35    25     0   1023.34306
%    0     5  1000   1044.12802
%    0    25  1000   1037.90204
%   35     5  1000   1069.48914
%   35    25  1000   1062.53817
% S0 = [ 0  0 35 35];
% T0 = [ 5 25  5 25];
% P0 = [ 0  0  0  0];
% S0 = [ 0  0 35 35];
% T0 = [ 5 25  5 25];
% P0 = [1000 1000 1000 1000];
%
% Siqi Li, SMAST
% 20201-06-17
%
% Updates:
%
%==========================================================================
function sigma = calc_sigma_millero(S0, T0, P0)


%-------------When there is no pressure------------------------------------

T = T0;
Tp2 = T.^2;
Tp3 = T.^3;
Tp4 = T.^4;
Tp5 = T.^5;
S = S0;

A =  8.24493e-1 - 4.0899e-3*T + 7.6438e-5*Tp2 - 8.2467e-7*Tp3 + 5.3875e-9*Tp4;
B = -5.72466e-3 + 1.0227e-4*T - 1.6546e-6*Tp2;
C =  4.8314e-4;

rho0 = 999.842594 + 6.793952e-2*T -9.095290e-3*Tp2 + 1.001685e-4*Tp3 - 1.120083e-6*Tp4 + 6.536336e-9*Tp5;

rho = rho0 + A.*S + B.*S.^1.5 + C.*S.^2;

sigma = rho - 1000;
% sva = 1./(1000+sigma) - 1/r3500;

%-------------When there is no pressure------------------------------------
ii = find(abs(P0)>1e-4);

if ~isempty(ii)

    T = T0(ii);
    Tp2 = T.^2;
    Tp3 = T.^3;
    Tp4 = T.^4;
    S = S0(ii);
    Sp15 = S.^1.5;
    P = P0(ii);
    
    a =    54.6746 -  0.603459*T + 1.09987e-2*Tp2 - 6.1670e-5*Tp3;
    b =   7.944e-2 + 1.6483e-2*T -  5.3009e-4*Tp2;
    c =  2.2838e-3 - 1.0981e-5*T -  1.6078e-6*Tp2;
    d = 1.91075e-4;
    e = -9.9348e-7 + 2.0816e-8*T + 9.1697e-10*Tp2;
    
    Kw =   19652.21 +   148.4206*T -   2.327105*Tp2 + 1.360477e-2*Tp3 -5.155288e-5*Tp4;
    Aw =   3.239908 + 1.43713e-3*T + 1.16092e-4*Tp2 -  5.77905e-7*Tp3; 
    Bw = 8.50935e-5 - 6.12293e-6*T +  5.2787e-8*Tp2;
    
    K0 = Kw + a.*S + b.*Sp15;
    A  = Aw + c.*S + d.*Sp15;
    B  = Bw + e.*S;
    
    K = K0 + A.*P + B.*P.^2;
    
    rho(ii) = rho(ii) ./ (1 - P./K);
    sigma(ii) = rho(ii) - 1000.;
end

end
