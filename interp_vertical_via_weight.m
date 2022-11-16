%==========================================================================
% Horizontal interpolatin via weights
%
% Input  : var1   (node1,nz)
%          id     (node,np)
%          weight (node,np)
%                 (np is the node number used for interpolation)
% Output : var2   (node2,nz)
%
% Siqi Li, SMAST
% 2020-03-18
%
% Updates:
%==========================================================================
function var2 = interp_vertical_via_weight(var1, weight_v, varargin)

dims1 = size(var1);


if length(dims1)==3
    var1 = reshape(var1, [], dims1(end));
end

id1=weight_v.id1;
id2=weight_v.id2;
w1=weight_v.w1;
w2=weight_v.w2;

% dimensions
[n,nz1]=size(var1);
nz2=size(id1,2);

% assign the output
tt1=nan(n,nz2);
tt2=nan(n,nz2);

k = find(~isnan(id1(:,1)));

% for i=1:n
for i = k(:)'
    tt1(i,:)=var1(i,id1(i,:));
    tt2(i,:)=var1(i,id2(i,:));
end

% Vertical interpolation via weights
var2 = tt1.*w1 + tt2.*w2;
    

if length(dims1)==3
    var2 = reshape(var2, dims1(1), dims1(2), []);
end

end