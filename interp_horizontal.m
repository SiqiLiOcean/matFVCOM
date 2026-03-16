function var2 = interp_horizontal(x1, y1, var1, x2, y2)

if length(size(var1))~=2
    error('The dimension number of input var1 is wrong')
end

[n1, n2] = size(var1);

node1 = length(x1);
node2 = length(x2);

if n1==node1
    nz = n2;
elseif n2==node1
    error('Transpose your input var1.')
else
    error('The size of input var1 is wrong.')
end
var1 = double(var1);

% Initialize var2
var2 = nan(node2, nz);

weight_h = interp_horizontal_calc_weight(x1, y1 ,x2, y2);
for iz = 1 : nz
    var2(:, iz) = interp_horizontal_via_weight(var1(:, iz), weight_h);
end

% % This mehtod was slower, compared with the one with weight
% % for iz = 1 : nz
% %     var_interp = griddata(x1, y1, var1(:,iz), x2, y2, 'linear');
% %     
% %     k = find(isnan(var_interp));
% %     if ~isempty(k)
% %         Idx = knnsearch([x1,y1], [x2(k),y2(k)]);
% %         var_interp(k) = var1(Idx,iz);
% % %         var_interp(k) = griddata(x1, y1, var1(:,iz), x2(k), y2(k), 'nearest');
% %     end
% %     var2(:, iz) = var_interp;
% % end
    