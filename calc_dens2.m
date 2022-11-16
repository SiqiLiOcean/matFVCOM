%==========================================================================
% To calculate the density from salinity and temperature.   
%
% Ref
% Fofonoff, N.P., 1962. Physical properties of seawater. In The Sea: Ideas 
% and observations on progress in the study of the seas, Vol, 1: Physical 
% Oceanography. M.N. Hill, ed., Wiley, Interscience, new York, pp. 3-30.	
%
% input  : S       salinity               (ipss-78)
%          PT      potential temperature  degree Celsius
%
% output : rho     density                kg/m3
%
% Siqi Li, SMAST
% 2021-06-18
%
% Updates:
%
%==========================================================================
function rho = calc_dens2(S, PT)


Tp2 = PT.^2;
Tp3 = PT.^3;

sigma0 =   6.8e-6*S.^3 - 4.82e-4*S.^2 +    0.8149*S - 0.093;
A      = 1.0843e-6*Tp3 - 9.818e-5*Tp2 + 4.7867e-3*PT;
B      = 1.667e-8*Tp3  - 8.164e-7*Tp2 + 1.803e-5*PT;
r_pure = (PT-3.98).^2 .* (PT+283.) ./ (503.73 * (PT+67.26));


sigma = (sigma0+0.1324) .* (1 - A + B.*(sigma0-0.1324)) - r_pure;

rho = sigma + 1000;

end