function L = isoline(xx, yy, zz, levels)

xl = xx(:,1);
yl = yy(1,:);

if length(levels) == 1
    levels = [levels levels];
end

C = contourc(xl, yl, zz, levels);


L = read_contourC(C);

    