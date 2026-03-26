function volume = f_calc_volume(f, zeta, varargin)

varargin = read_varargin2(varargin, {'Abnormal'});

nt = size(zeta, 2);


if isscalar(zeta)
    zeta = zeros(f.node, nt);
end


art1 = f_calc_art1(f);
h = f.h;

if Abnormal
    h = h * 0;
end


volume = nan(nt, 1);
for it = 1 : nt

    volume(it) = (h+zeta(:,it))' * art1;
    % volume(it) = art1 .* (h + zeta(:, it));
end