%==========================================================================
% matFVCOM package
% 
%
% input  :
%   month_val --- the values of 12 months from Jan. to Dec.
%   out_t     --- the target time (in datenum)
% 
% output :
%   out_val   --- the interpolated value
%
% Siqi Li, SMAST
% 2024-09-11
%
% Updates:
%
%==========================================================================
function out_val = interp_month2time(month_val, out_t)

vec = datevec(min(out_t));
year1 = vec(1) - 1;
vec = datevec(max(out_t));
year2 = vec(1) + 1;

in_t = [];
in_val = [];
for year = year1 : year2
    in_t = [in_t (datenum(year, 1:12, 1)+datenum(year, 2:13,1))/2];
    in_val = [in_val month_val];
end

out_val = interp1(in_t, in_val, out_t);

end