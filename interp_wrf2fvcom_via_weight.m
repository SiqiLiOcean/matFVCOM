%==========================================================================
% matFVCOM package
%   interp WRF-grid variables to FVCOM-grid ones (via weights)
%
% input  :
%   w
%   f
%   type
% 
% output :
%   weight
%
% Siqi Li, SMAST
% 2023-09-16
%
% Updates:
%
%==========================================================================
function dst = interp_wrf2fvcom_via_weight(src, weight, varargin)



% Do the interpolation
ndomain = length(weight);
n = 0;
for i = 1 : ndomain
    n = n + length(weight{i}.id);
end
src_dims = size(src{1});
dst_dims = [n src_dims(3:end)];
if numel(dst_dims) == 1
    dst_dims = [dst_dims 1];
end
dst = nan(dst_dims);

for i = 1 : ndomain
    if ~isempty(weight{i}.w)
        dst(weight{i}.id,:) = interp_2d_via_weight(src{i}, weight{i}.w);
    end
end