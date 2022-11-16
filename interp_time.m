%==========================================================================
%
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% 2022-11-08
%
% Updates:
%
%==========================================================================
function var2 = interp_time(var1, time1, time2)

weight_t = interp_time_calc_weight(time1, time2);

var2 = interp_time_via_weight(var1, weight_t);

