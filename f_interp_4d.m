function varout = f_interp_4d(fgrid, tin, varin, xout, yout, zout, tout)

% fgrid = f;
% xout = obs(:,1);
% yout = obs(:,2);
% zout = obs(:,3);
% tout = obs(:,4);
% tin = datenum(2012,10,28):1/24:datenum(2012,10,31);
% varin = temp1;


xout = xout(:);
yout = yout(:);


xin = fgrid.x;
yin = fgrid.y;
nv = fgrid.nv;

if size(varin, 1) == fgrid.nele
    varin = f_interp_cell2node(fgrid, varin);
end

if size(varin, 2) == fgrid.kbm1
    zin = fgrid.deplay;
else
    zin = fgrid.deplev;
end

n = length(xout);
varout = nan(n, 1);

dd = [nan; sqrt( (xout(2:n) - xout(1:n-1)).^2 + (yout(2:n) - yout(1:n-1)).^2)];
for i = 1 : n
    
    % Find the cell location
    if dd(i)<1e-5
        % Nothing need to do
        % The w_cell and icell from last step of loop will be used.
    else
        icell = f_find_cell(fgrid, xout(i), yout(i));
        A = [xin(nv(icell,:))'; yin(nv(icell,:))'; 1 1 1];
        b = [xout(i); yout(i); 1];
        w_cell = A \ b;
    end
    
    % Find the time
    dt = tin -tout(i);
%     it2 = max([min(find(dt>=0)), 2]);
    it2 = max([find(dt>0, 1), 2]);
    it1 = it2-1;
    w_t1 = (tin(it2)-tout(i)) / (tin(it2)-tin(it1));
    w_t2 = (tout(i)-tin(it1)) / (tin(it2)-tin(it1));
    
    % 1> interp on time
    varin_t1 = varin(nv(icell,:), :, it1);
    varin_t2 = varin(nv(icell,:), :, it2);
    varin_t = varin_t1*w_t1 + varin_t2*w_t2;
    
    % 2> interp on depth
    varin_t_z = interp_vertical(zin(nv(icell,:), :), varin_t, repmat(zout(i), 3, 1));
%     weight_v = interp_vertical_calc_weight(zin(nv(icell,:), :), repmat(zout(i), 3, 1));
    
    % 3> interp horizontally
    varout(i) =  varin_t_z' * w_cell;
    
end  
    
    