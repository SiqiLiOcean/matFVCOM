%==========================================================================
% Generate the vertical interpolation weights
% Method : 
%   Linear interpolation
%   1) above the min-depth, value equals to that at min-depth
%   2) below the max-depth, value equals to that at max-depth
%   3) otherwise, use values of the two neighbor layers to calculate
%           (depth1,T1) ===   source depth1
%                        |
%                        |
%           (depth ,T ) ---   destination depth
%                        |
%                        |
%                        |
%           (depth2,T2) ===   source depth2
%         
%        T= w1*T1 +w2*T2
%      where w1 = (depth2-depth ) / (depth2-depth1)
%            w2 = (depth -depth1) / (depth2-depth1)
% 
% Input  : depth1 (n,nz1), positive for water depth
%          depth2 (n,nz2), positive for water depth
%          'list' (optional) list of the nodes that need to be interpolated 
% 
% Output : weight_v (cell)
%           -id (n,2)
%           -w (n,2)
%
% Siqi Li, SMAST
% 2020-03-18
%
% Updates:
%==========================================================================
function weight_v = interp_vertical_calc_weight(z1, z2, varargin)


% dimensions
[n1,nz1] = size(z1);
[n2,nz2] = size(z2);

if n1~=n2
    disp([n1,n2])
    error('The node # of depth1 and depth2 do not equal.')
else
    n = n1;
end


% k=1;
% list=1:1:n;
% % 'list'
% while k<=length(varargin)
%     switch lower(varargin{k}(1:4))
%         case 'list'
%             list=varargin{k+1};
%     end
%     k=k+2;
% end
varargin = read_varargin(varargin, {'List'}, {1:n});


% assign the output
id1=nan(n,nz2);
id2=nan(n,nz2);
w1=nan(n,nz2);
w2=nan(n,nz2);

% Use the first point to get the increasing direction of depth.
if z1(1,1)==min(z1(1,:))
    iz_min = 1;
    iz_max = nz1;
elseif z1(1,nz1)==min(z1(1,:))
    iz_min = nz1;
    iz_max = 1;
else
    error('z1 is not increasing monotonely.')
end


for i=List(:)'

    % For shallower layers, use the upper layer value.
    iz_shallow=find(z2(i,:)<=z1(i,iz_min));
    id1(i,iz_shallow)=iz_min;
    id2(i,iz_shallow)=iz_min;
    w1(i,iz_shallow)=1;
    w2(i,iz_shallow)=0;
    %     id(i,iz_shallow)=1;
    %     weight(i,iz_shallow)=1;
    
    % For the deeper layers, use the lower layer value.
    iz_deep=find(z2(i,:)>=z1(i,iz_max));
    id1(i,iz_deep)=iz_max;
    id2(i,iz_deep)=iz_max;
    w1(i,iz_deep)=1;
    w2(i,iz_deep)=0;
    %     id(i,iz_deep)=nz1;
    %     weight(i,iz_deep)=1;
    
    % For the middle layers
    id_middle=find(z2(i,:)>z1(i,iz_min) & z2(i,:)<z1(i,iz_max));
    
    for iz=id_middle(:)'
        if iz_min==1
            id1(i,iz)=max(find(z1(i,:)-z2(i,iz)<0));
        else
            id1(i,iz)=max(find(z1(i,:)-z2(i,iz)>0));
        end
        id2(i,iz)=id1(i,iz)+1;
        
        w1(i,iz)=(z1(i,id2(i,iz))-z2(i,iz)) / ((z1(i,id2(i,iz)))-z1(i,id1(i,iz)));
        w2(i,iz)=1-w1(i,iz);
    end
    
    %     var2(i,:)=interp1(depth1(i,:),var1(i,:),depth2(i,:));
    %
    %     % For shallower layers, use the upper layer value.
    %     iz_shallow=find(depth2(i,:)<=depth1(i,1));
    %     var2(i,iz_shallow)=var1(i,1);
    %     % For the deeper layers, use the lower layer value.
    %     iz_deep=find(depth2(i,:)>=depth1(i,nz1));
    %     var2(i,iz_deep)=var1(i,nz1);
    
    
end


% Merge the weight and id into one cell
weight_v.id1=id1;
weight_v.id2=id2;
weight_v.w1=w1;
weight_v.w2=w2;
