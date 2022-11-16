%==========================================================================
% Calculate relative humidity at 2m (RH2) using WRF output
% Re-write based on ARWPost/module_calc_rh2.f90
%
% input : T2, 2m air temperature, K
%         PSFC, surface air pressure, Pa
%         Q2, 2m air QV, kg/kg
% output: RH2, %
%
% Siqi Li, SMAST
% 2021-09-14
%
% Updates:
%
%==========================================================================
function RH2 = calc_rh2(T2, PSFC, Q2)

% Parameters
T0=273.16;
EPS=0.622;


tmp1=10*0.6112*exp(17.67*(T2-T0)./(T2-29.65));
tmp2=EPS*tmp1 ./ (0.01*PSFC-(1-EPS)*tmp1);
RH2=100 * Q2./tmp2;

RH2=min(RH2,100.);
RH2=max(RH2,0.);

end
