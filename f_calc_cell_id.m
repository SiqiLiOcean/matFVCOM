function id = f_calc_cell_id(fgrid, x0, y0)


nv = fgrid.nv;
x = fgrid.x;
y = fgrid.y;
xc = fgrid.xc;
yc = fgrid.yc;

x0 = x0(:);
y0 = y0(:);
n0 = length(x0);

k = knnsearch([xc yc], [x0, y0], 'K',10);


id = nan(n0, 1);
for i = 1 : n0
    
    tri_x = x(nv(k(i,:),:));
    tri_y = y(nv(k(i,:),:));
    
    in = if_in_triangles(tri_x, tri_y, [x0(i) y0(i)]);
    
    in_id = find(in);
    in_id = in_id(1);
    
    id(i) = k(i, in_id);
    
end

end


function in = if_in_triangles(tri_x, tri_y, p0)

px1 = tri_x(:,1);
py1 = tri_y(:,1);

px2 = tri_x(:,2);
py2 = tri_y(:,2);

px3 = tri_x(:,3);
py3 = tri_y(:,3);

px0 = p0(1);
py0 = p0(2);


d1 = (px0-px2).*(py1-py2) - (px1-px2).*(py0-py2);
d2 = (px0-px3).*(py2-py3) - (px2-px3).*(py0-py3);
d3 = (px0-px1).*(py3-py1) - (px3-px1).*(py0-py1);

% dd = [d1 d2 d3];
in = (d1>=0 & d2>=0 & d3>=0) | (d1<=0 & d2<=0 & d3<=0);



end





