function [lx2, ly2] = line_in_box(lx, ly, xlims, ylims)

boxx = xlims([1 2 2 1 1]);
boxy = ylims([1 1 2 2 1]);
% Calculate the intersect points
[xi, yi, ii] = polyxpoly(lx, ly, boxx, boxy);
ii = ii(:,1);

% % Remove the duplicated points  
% [~, ia] = unique([xi yi], 'rows', 'stable');
% xi = xi(ia);
% yi = yi(ia);
% ii = ii(ia);

% Sort the intersect points
[~, ib] = sort(ii, 'descend');
xi = xi(ib);
yi = yi(ib);
ii = ii(ib);


% Put intersect points into the line
lx2 = lx;
ly2 = ly;
for i = 1: length(ii)
    lx2 = [lx2(1:ii(i)) xi(i) lx2(ii(i)+1:end)];
    ly2 = [ly2(1:ii(i)) yi(i) ly2(ii(i)+1:end)];
end

% Remove the outside points
I_in = inpolygon(lx2, ly2, boxx, boxy);
I_nan = isnan(lx2);
lx2(~I_in&~I_nan) = [];
ly2(~I_in&~I_nan) = [];
