%==========================================================================
%
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% 2022-11-07
%
% Updates:
%
%==========================================================================
function var_out = interp_time_via_weight(var0, weight_t)

it = weight_t.it(:)';
w = weight_t.w(:)';

dims0 = size(var0);
if length(dims0) == 2 && dims0(2) == 1
    var0 = var0(:)';
    dims0 = size(var0);
end
nt = length(it);


var1 = reshape(var0, [], dims0(end));

% for i = 1 : size(var1,1)
%     var2(i,:) = var1(i,it).*w + var1(i,it+1).*(1-w);
% end
var2 = var1(:,it) .* repmat(w,size(var1,1),1) + var1(:,it+1) .*  (1-repmat(w,size(var1,1),1));

var_out = reshape(var2, [dims0(1:end-1) nt]);