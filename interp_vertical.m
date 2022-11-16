%==========================================================================
% Vertical interpolatin
%
% Input  : depth1 (node,nz1)
%          var1   (node,nz1)
%          depth2 (node,nz2)
%          'list' (optional) list of the nodes that need to be interpolated 
% Output : var2   (node,nz2)
%
% Note : The depth1 and depth2 are all positive, and should be increasing.
%
% Siqi Li, SMAST
% 2020-02-07
%
% Updates:
% 2020-03-16  Siqi Li, Add the 'list' option, for only do interpolation for
%                      the nodes in the 'list'.
% 2020-07-03  Siqi Li, Fixed the error when depth1 and depth2 are in 
%                      different directions
%==========================================================================
function var2 = interp_vertical(var1, depth1, depth2, varargin)





weight_v = interp_vertical_calc_weight(depth1, depth2, varargin{:});

var2 = interp_vertical_via_weight(var1, weight_v);



% % dimensions
% node=size(depth1,1);
% % nz1=size(depth1,2);
% nz2=size(depth2,2);
% 
% 
% k=1;
% list=1:1:node;
% % 'list'
% while k<=length(varargin)
%     switch lower(varargin{k}(1:4))
%         case 'list'
%             list=varargin{k+1};
%     end
%     k=k+2;
% end
% 
% % assign the output
% var2=nan(node,nz2);
% 
% % Vertical interpolation
% % for i=1:node
% for i=list(:)'
% 
%     var2(i,:)=interp1(depth1(i,:),var1(i,:),depth2(i,:));
% 
%     
%     iz1_min = find(depth1(i,:)==min(depth1(i,:)));
%     iz1_max = find(depth1(i,:)==max(depth1(i,:)));
%     
%     % For shallower layers, use the upper layer value.
%     iz_shallow=find(depth2(i,:)<=depth1(i,iz1_min));
%     var2(i,iz_shallow)=var1(i,iz1_min);
%     
%     % For the deeper layers, use the lower layer value.
%     iz_deep=find(depth2(i,:)>=depth1(i,iz1_max));
%     var2(i,iz_deep)=var1(i,iz1_max);
%     
% end
    
