%IS_LEAP   Check whether a year is a leap year.
%
%   tf = IS_LEAP(year)
%
%   Input:
%       year - scalar or vector of years (e.g., 1980 or [1980 1981 1982]).
%
%   Output:
%       tf   - logical array, true for leap years.
%
% Rule:
% A year is a leap year if:
%   divisible by 4 AND NOT divisible by 100
%   OR divisible by 400
function tf = is_leap(year)

    
    tf = (mod(year, 4) == 0 & mod(year, 100) ~= 0) | ...
         (mod(year, 400) == 0);
end
