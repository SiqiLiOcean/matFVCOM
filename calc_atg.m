%==========================================================================
% Calculate the adiabatic lapse-rate of temperature, in terms of in situ 
%   temperature (degree C), salinity (1e-4), and oceanographic pressure 
%   (dbar). 
%
% Ref:
%   Bryden, 1973: New polynomials for thermal expansion, adiabatic
%     temperature gradient and potential temperature of sea water, Deep-Sea
%     Research, Vol. 20, 401-408. (Page 404, Table 4)
%   
% input  : S, Salinity                           1e-4
%          T, Temperature                        degree C
%          P, oceanographic pressure             dbar 
%          (This subroutine has been vectorized.) 
%
% output : atg, adiabatic temperature gradient   degree C / dbar
%
% check value 1 (from paper):
%              S = 25; T = 10; P = 10000;
%              atg = calc_atg(S, T, P);  % should be 0.00020687417
% check value 2 (from FVCOM eqs_of_state.F ATG):
%              S = 40; T = 40; P = 10000;
%              atg = calc_atg(S, T, P);  % should be 0.00032559758
%
% Range:   S : [30, 40]
%          T : [-2, 30]
%          P : [0, 10000];
%
% Siqi Li, SMAST
% 2021-06-17
%
% Updates:
%
%==========================================================================
function atg = calc_atg(S, T, P)


% S = 25;
% T = 10;
% P = 10000;

A000 =  0.35803e-1;
A001 =  0.85258e-2;
A002 = -0.68360e-4;
A003 =  0.66228e-6;
A010 =  0.18932e-2;
A011 = -0.42393e-4;
A100 =  0.18741e-4;
A101 = -0.67795e-6;
A102 =  0.87330e-8;
A103 = -0.54481e-10;
A110 = -0.11351e-6;
A111 =  0.27759e-8;
A200 = -0.46206e-9;
A201 =  0.18676e-10;
A202 = -0.21687e-12;

S = S - 35;

% i = 0, 1, 2
% j = 0, 1
% k = 0, 1, 2, 3
P0 = P .^ 0;
P1 = P;
P2 = P .^ 2;
S0 = S .^0;
S1 = S;
T0 = T .^0;
T1 = T;
T2 = T .^ 2;
T3 = T .^ 3;

atg = A000 * P0 .* S0 .* T0 + ...
      A001 * P0 .* S0 .* T1 + ...
      A002 * P0 .* S0 .* T2 + ...
      A003 * P0 .* S0 .* T3 + ...
      A010 * P0 .* S1 .* T0 + ...
      A011 * P0 .* S1 .* T1 + ...
      A100 * P1 .* S0 .* T0 + ...
      A101 * P1 .* S0 .* T1 + ...
      A102 * P1 .* S0 .* T2 + ...
      A103 * P1 .* S0 .* T3 + ...
      A110 * P1 .* S1 .* T0 + ...
      A111 * P1 .* S1 .* T1 + ...
      A200 * P2 .* S0 .* T0 + ...
      A201 * P2 .* S0 .* T1 + ...
      A202 * P2 .* S0 .* T2;
      
% Convert unit from degree C / 1000 dbar to degree C/dbar  
atg = atg * 1e-3;      

end
