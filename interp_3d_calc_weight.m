%==========================================================================
% 3-D Interpolation
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% 2022-09-28
%
% Updates:
% 2022-10-03  Siqi Li  Added more methods for horizontal interpolation
%==========================================================================
function weight = interp_3d_calc_weight(depth1, std, depth2, method, varargin)  

if isempty(std)
    std = [0:2:12 15:5:50 60:10:100 125:25:150 200:50:400 ...
   500:100:900 1000:250:1500 2000:500:3000 4000 5000];
end

n1 = length(varargin{1});
n2 = length(varargin{4}); 
varargin = read_varargin(varargin, {'List1'}, {1:n1});
varargin = read_varargin(varargin, {'List2'}, {1:n2});


% vertical interpolation from fgrid1 sigma to standard depth 
weight.v1 = interp_vertical_calc_weight(depth1, repmat(std(:)',n1,1), 'List', List1);

% 2d horizontal interpolation from fgrid1 to fgrid2
% weight.h = interp_horizontal_calc_weight(x1, y1, x2, y2);  % 204s ---> 2s
switch method
    case 'TRI'
        weight.h = interp_2d_calc_weight(method, varargin{:});
    otherwise
        weight.h = interp_2d_calc_weight(method, varargin{:});
end

% vertical interpolation from standard depth to fgrid2 sigma
weight.v2 = interp_vertical_calc_weight(repmat(std(:)',n2,1), depth2, 'List', List2);

