%==========================================================================
% Calculate Coriolis 
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% 2021-10-28
%
% Updates:
%
%==========================================================================
function cor = calc_cor(lat)

rot = 7.2921e-5;   % unit : rad/s

cor = 2 * rot .* sind(lat); 



