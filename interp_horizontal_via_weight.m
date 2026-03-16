%==========================================================================
% Horizontal interpolatin via weights
%
% Input  : var1   (node1,nz)
%          weight_h (cell)
%           -id     (node,np)
%           -weight (node,np)
%                 (np is the node number used for interpolation)
% Output : var2   (node2,nz)
%
% Siqi Li, SMAST
% 2020-02-07
%
% Updates:
%  2020-03-18  Siqi Li, The id and weight has been merged into one cell for
%                       input
%  2020-03-06  Siqi Li, Suitable to interpolate the 1-layer data
%==========================================================================
function var2 = interp_horizontal_via_weight(var1,weight_h)

id=weight_h.id;
weight=weight_h.w;

% the 1-layer var should be in the shape [node1, 1]
var1_size=size(var1);
if (var1_size(1)==1 && var1_size(2)~=1)
    var1=var1(:);
end

% dimensions
node1=size(var1,1);
node2=size(id,1);
nz=size(var1,2);

% assign the output
var2=nan(node2,nz);


% Horizontal interpolation via weights
for i=1:nz
    
    var2(:,i)=sum(reshape(var1(id,i),node2,size(id,2)) .* weight, 2);

end
    
end