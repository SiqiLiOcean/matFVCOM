%==========================================================================
% Format the number with certain digits.
%
% input  :
%   data0 --- input data
%   digit ---
%   'round', 'floor', 'ceil' --- optional methods
%
% output :
%   data1 --- output data
%
% Usage:
%   keep the two digits after the decimal point:
%     data1 = format_num(data0, 0.01, 'round');
%
% Siqi Li, SMAST
% 2022-04-13
%
% Updates:
%
%==========================================================================
function data1 = format_num(data0, digit, varargin)

% varargin = read_varargin(varargin, {'Method'}, {'round'});
if isempty(varargin)
    Method = 'round';
else
    Method = lower(varargin{:});
end

switch Method
    case 'round'
        data1 = round(data0/digit) * digit;
    case 'floor'
        data1 = floor(data0/digit) * digit;
    case 'ceil'
        data1 = ceil(data0/digit) * digit;
    otherwise
        error('Unknown method. Use round, floor, or ceil')
end


end
    