%==========================================================================
% Calculate RMSE
%
% input  :
%   v1 --- matrix 1
%   v2 --- matrix 2
% 
% output :
%   rmse
%
% Siqi Li, SMAST
% 2022-11-08
%
% Updates:
%
%==========================================================================
function rmse = calc_rmse(v1, v2, varargin)

varargin = read_varargin2(varargin, {'Direction'});

v1 = v1(:);
v2 = v2(:);

id = find(~isnan(v1+v2));

err = v1(id) - v2(id);
if ~isempty(Direction)
    err = mod(err+180, 360) - 180;
end

rmse = sqrt( sum(err.^2) / length(id) );