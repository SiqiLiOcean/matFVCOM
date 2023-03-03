%==========================================================================
% Do the 2d interpolation with different kind of data in three different
% ways:
%   1> For triangle-grid (such as FVCOM node), use the Triangulation with Linear
%      Interpolation Method. (TRI)
%   2> For rectangule-grid (such as WRF), use the Bilinear / Quadrilateral
%      Interpolation Method.(BI) 
%   3> For random scattered points, use the Inversed Distance Method. (ID)
%
% This function will do the whole interpolation.
%
% input  : METHOD_2D, varargin
%    METHOD_2D    interpolation method, 'TRI', 'BI', 'QU', 'ID', 'GLOBAL_BI'
%    varargin contains:
%    1> 'TRI'
%       x           source x
%       y           source y
%       nv          source nv
%       xo          destination x
%       yo          destination y
%       'Extrap'    the flag to do extrapolation (optional)
%       'K'         the points to be searched, if there are NaN points in 
%                     the domain, try to increase this value (optional, 
%                     default 7)
%
%    2> 'BI'
%       x           source x
%       y           source y
%       xo          destination x
%       yo          destination y
%       'Global'    the flag to solve the global grid problem (optional)
%
%    3> 'QU'
%       x           source x
%       y           source y
%       xo          destination x
%       yo          destination y
%       'Extrap'    the flag to do extrapolation (optional)
%
%    4> 'ID'
%       x           source x
%       y           source y
%       xo          destination x
%       yo          destination y
%       'np'        the flag to do extrapolation (optional)
%       'Power'     the order of distance in the ID equation (optional, 
%                     default 2)
%    5> 'GLOBAL_BI'
%       x           source x (array)
%       y           source y (array)
%       xo          destination x
%       yo          destination y
%    6> 'NEAREST'
%       x           source x (array)
%       y           source y (array)
%       xo          destination x
%       yo          destination y
% output :
%    var2       output
%
% Siqi Li, SMAST
% 2021-06-22
%
% Updates:
% 2023-01-04  Siqi Li  Added GLOBAL_BI
%==========================================================================
function var2 = interp_2d(var1, METHOD_2D, varargin)


% First calculate the weight.
weight_h = interp_2d_calc_weight(METHOD_2D, varargin{:});

% Then do the interpolation.
if strcmpi(METHOD_2D, 'TRI')
    if size(var1,1) == size(varargin{3},1)
        f = f_load_grid(varargin{1}, varargin{2}, varargin{3});
        var1 = f_interp_cell2node(f, var1);
    end
end

var2 = interp_2d_via_weight(var1, weight_h);

end