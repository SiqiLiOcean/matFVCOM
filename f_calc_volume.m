function volume = f_calc_volume(f, zeta)

if isscalar(zeta)
    zeta = zeros(f.node, 1);
end

nt = size(zeta, 2);

art1 = f_calc_art1(f);
h = f.h;

volume = nan(nt, 1);
for it = 1 : nt

    volume(it) = (h+zeta(:,it))' * art1;
end