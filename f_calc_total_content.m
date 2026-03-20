function [content, V] = f_calc_total_content(f, zeta, var)

if size(var,1) ~= f.node
    disp(size(var,1))
    error('The number of columns in var must match the number of nodes in f.');
end

nt = size(var, 3);
nz = f.kbm1;

if isscalar(zeta)
    zeta = size(f.node, nt);
end

art1 = f_calc_art1(f);
siglev = f.siglev;
h = f.h;


content = nan(nt, 1);
for it = 1 : nt
    var_time = nan(nz,1);
    for iz = 1 : nz
        slice = (siglev(:,iz) - siglev(:,iz+1)) .* (h+zeta(:,it)) .* art1 .* var(:,iz,it);
        var_time(iz) = sum(slice);
    end
    content(it) = sum(var_time);
end

V = sum(art1 .* zeta,1) ;