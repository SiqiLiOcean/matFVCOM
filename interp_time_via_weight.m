%==========================================================================
%
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% 2022-11-07
%
% Updates:
%
%==========================================================================
function var2 = interp_time_via_weight(var1, weight_t)

it = weight_t.it;
w = weight_t.w;



var2 = var1(it).*w + var1(it+1).*(1-w);
