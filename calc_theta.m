%==========================================================================
% Calculate the potential temperature
%
% Ref:
%   *Fofonoff, 1977, Computation of potential temperature of seawater for an
%     arbitrary reference pressure, Deep-Sea, Vol. 24, 489-491. (Page 490, 
%     Eq. 3 and 4)
%   Bryden, 1973: New polynomials for thermal expansion, adiabatic
%     temperature gradient and potential temperature of sea water, Deep-Sea
%     Research, Vol. 20, 401-408. (Page 404, Table 4)
%   
%   (* There is an typo in the q2 and q3 parts of Eq. 3. The right one
%      should be:
%          q2 = (2-sqrt(2))*dtheta2 + (-2+3/sqrt(2))*q1
%          q3 = (2+sqrt(2))*dtheta2 + (-2-3/sqrt(2))*q2
%      The correct one can be found in 'Algorithms for computation of
%      fundamental properties of seawater', Page 43.)
%
% input  : S,  Salinity                           1e-4
%          T,  Temperature                        degree C
%          P,  oceanographic pressure             dbar 
%          Pr, reference pressure                 dbar
%          (This subroutine has been vectorized.) 
%
% output : theta, potential temperature           degree C
%
% check value 1 (from 'Algorithms for computation of fundamental 
%   properties of seawater'):
%              S = 40; T = 40; P = 10000; Pr = 0;
%              theta = calc_theta(S, T, P, Pr);  % should be 36.89073
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
function theta = calc_theta(S, T, P, Pr)


% S = 40;
% T = 40;
% P = 10000;
% Pr = 0;

theta0 = T;

dP = Pr - P;

dtheta1 = dP .* calc_atg(S, theta0, P);
theta1  = theta0 + 0.5 * dtheta1;
q1      = dtheta1;

dtheta2 = dP .* calc_atg(S, theta1, P+0.5*dP);
theta2  = theta1 + (1-1/sqrt(2))*(dtheta2-q1);
q2      = (2-sqrt(2))*dtheta2 + (-2+3/sqrt(2))*q1;
% q2      = (2-sqrt(2))*dtheta2 + (-2+3/sqrt(2))*dtheta1;


dtheta3 = dP .* calc_atg(S, theta2, P+0.5*dP);
theta3  = theta2 + (1+1/sqrt(2))*(dtheta3-q2);
q3      = (2+sqrt(2))*dtheta3 + (-2-3/sqrt(2))*q2;
% q3      = (2+sqrt(2))*dtheta3 + (-2-3/sqrt(2))*dtheta2;


dtheta4 = dP .* calc_atg(S, theta3, P+dP);
theta4  = theta3 + 1/6*(dtheta4-2*q3);

theta = theta4;

end
