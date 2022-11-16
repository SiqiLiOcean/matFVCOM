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
function weight_t = interp_time_calc_weight(time1, time2)



nt1 = length(time1);
nt2 = length(time2);

for i = 1 : nt2
    if time2(i) <= time1(1)
        it(i) = 1;
        w(i) = 1;
    elseif time2(i) >=  time1(end)
        it(i) = nt1-1;
        w(i) = 0;
    else
        it(i) = sum(time2(i)-time1>=0);
        w(i) = (time1(it(i)+1) - time2(i)) / (time1(it(i)+1) - time1(it(i)));
    end
end

weight_t.it = it;
weight_t.w = w;
