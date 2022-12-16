%==========================================================================
% Do the 2d interpolation with different kind of data in three different
% ways:
%   1> For triangle-grid (such as FVCOM node), use the Triangulation with Linear
%      Interpolation Method. (TRI)
%   2> For rectangule-grid (such as WRF), use the Bilinear / Quadrilateral
%      Interpolation Method.(BI) 
%   3> For random scattered points, use the Inversed Distance Method. (ID)
%
% This function will do the interpolation using the weight.
%
% input  : 
%     weight_h   weight cell, from interp_2d_calc_weight
%     var1       input
% 
% output :
%     var2       output
%
% Siqi Li, SMAST
% 2021-06-22
%
% Updates:
% 2022-03-02  Siqi Li  Added the global option in BI method
%==========================================================================
function var2 = interp_2d_via_weight(var1, weight_h)



% Extract variables from weight cell
% method = weight_h.method;
dims1 = weight_h.dims1;
dims2 = weight_h.dims2;
id = weight_h.id;
w = weight_h.w;



if any(dims1==1)
    d1 = 1;
else
    d1 = 2;
end
if any(dims2==1)
    d2 = 1;
else
    d2 = 2;
end

n1 = prod(dims1);
n2 = prod(dims2);
% % 
% % dims_var1 = size(var1);
% % 
% % % Find the location dimension(s) in the var1.
% % if prod(dims_var1(1)) == prod(dims1)
% %     d1_loc = 1;
% % elseif prod(dims_var1(1:2)) == prod(dims1)
% %     d1_loc = 2;
% % else
% %     error('The size of input VAR1 is wrong.')
% % end
% % % Find the location dimension(s) in the var2.
% % if n2 == dims2(1)
% %     d2_loc = 1;
% % elseif n2 == dims2(1)*dims2(2)
% %     d2_loc = 2;
% % else
% %     error('The size of input VAR2 is wrong.')
% % end


if d1 == 1
    [var1, dims_var1] = dims_tar(var1, 1);
else
    [var1, dims_var1] = dims_tar(var1, 3);
end  
n_slice = size(var1, 2);


if ~isempty(weight_h.index)
    var1 = var1(weight_h.index,:);
end

% var1 = reshape(var1, n1, []);
% n_slice = size(var1, 2);
% dims_var2 = [dims2(1:d2_loc) dims_var1(d1_loc+1:end)];
% if length(dims_var2) == 1
%     dims_var2 = dims2;
% end


% Initialization
var2 = nan(n2, n_slice);
      

% Interpolation
k = find(~isnan(id(:,1)));
for i = 1 : n_slice
    if length(k) == 1
        tmp = var1(:,i);
        tmp = tmp(id(k,:))';
        var2(k, i) = sum(tmp.*w(k,:), 2);
        %    var2(k, i) = sum(tmp'.*w(k,:), 2);
    else
        tmp = var1(:,i);
        tmp = tmp(id(k,:));
        var2(k, i) = sum(tmp.*w(k,:), 2);
        %    var2(k, i) = sum(tmp'.*w(k,:), 2);
    end
end


% Reshape the output mathix.
if d2 == 1
    var2 = dims_untar(var2, [dims2(1) dims_var1(d1+1:4)], 1);
else
    var2 = dims_untar(var2, [dims2(1:2) dims_var1(d1+1:4)], 3);
end
% var2 = reshape(var2, dims_var2);

end
