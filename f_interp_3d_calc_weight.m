function weight = f_interp_3d_calc_weight(fgrid1, var1, fgrid2, std)

if length(size(var1))~=2
    error('The dimension number of input var1 is wrong')
end

[k1, k2] = size(var1);

if k1==fgrid1.node && k2==fgrid1.kbm1
    x1 = fgrid1.x;
    y1 = fgrid1.y;
    x2 = fgrid2.x;
    y2 = fgrid2.y;
    n1 = fgrid1.node;
    n2 = fgrid2.node;
    depth1 = fgrid1.deplay;
    depth2 = fgrid2.deplay;
elseif k1==fgrid1.node && k2==fgrid1.kb
    x1 = fgrid1.x;
    y1 = fgrid1.y;
    x2 = fgrid2.x;
    y2 = fgrid2.y;
    n1 = fgrid1.node;
    n2 = fgrid2.node;
    depth1 = fgrid1.deplev;
    depth2 = fgrid2.deplev;
elseif k1==fgrid1.nele && k2==fgrid1.kbm1
    x1 = fgrid1.xc;
    y1 = fgrid1.yc;
    x2 = fgrid2.xc;
    y2 = fgrid2.yc;
    n1 = fgrid1.nele;
    n2 = fgrid2.nele;
    depth1 = fgrid1.deplayc;
    depth2 = fgrid2.deplayc;
elseif k1==fgrid1.nele && k2==fgrid1.kb
    x1 = fgrid1.xc;
    y1 = fgrid1.yc;
    x2 = fgrid2.xc;
    y2 = fgrid2.yc;
    n1 = fgrid1.node;
    n2 = fgrid2.node;
    depth1 = fgrid1.deplevc;
    depth2 = fgrid2.deplevc;
else
    error('The size of input var1 is wrong.')
end

% vertical interpolation from fgrid1 sigma to standard depth 
weight.v1 = interp_vertical_calc_weight(depth1, repmat(std,n1,1));

% 2d horizontal interpolation from fgrid1 to fgrid2
% weight.h = interp_horizontal_calc_weight(x1, y1, x2, y2);  % 204s ---> 2s
weight.h = interp_2d_calc_weight('ID', x1, y1, x2, y2);


% vertical interpolation from standard depth to fgrid2 sigma
weight.v2 = interp_vertical_calc_weight(repmat(std,n2,1), depth2);

