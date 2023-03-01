%==========================================================================
% matFVCOM package
% Interpolate in ESMF style
%
% input  :
%   src_field --- source varaible
%   weight    --- read via esmf_read_weight
%   *Dims     --- destination variable size  {[]}
%   **Extrap  --- invoke extrapolation
% output :
%   dst_field --- destination variable
%
% Siqi Li, SMAST
% 2023-03-01
%
% Updates:
%
%==========================================================================
function dst_field = esmf_regrid(src_field, weight, varargin)

varargin = read_varargin(varargin, {'Dims'}, {[]});
varargin = read_varargin2(varargin, {'Extrap'});



row = weight.row;
col = weight.col;
S = weight.S;

src_field = reshape(src_field, weight.n_a, []);
n = size(src_field, 2);

if (n>1)
    error(['esmf_regrid does not support variables with the dimention ' ...
           'of 3 or higher. Use loops instead. '])
end

% Initialize destination field to 0.0
dst_field = zeros(weight.n_b, 1);

% Apply weights
for i = 1 : weight.n_s
    dst_field(row(i)) = dst_field(row(i)) + S(i)*src_field(col(i));
end

% Adjust destination field by fraction
dst_field = dst_field ./ weight.frac_b;

% Extrapolation
if ~isempty(Extrap)
    dst_field(weight.out) = src_field(weight.out_id);
end


if ~isempty(Dims)
    dst_field = reshape(dst_field, Dims);
end



