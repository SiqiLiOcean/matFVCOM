%==========================================================================
% Calculate gradient of FVCOM variables (based on cell)
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% 2021-10-28
%
% Updates:
%
%==========================================================================
function [dx, dy] = f_calc_gradient(fgrid, var)


x = fgrid.x;
y = fgrid.y;
nv = fgrid.nv;
node = fgrid.node;
nele = fgrid.nele;


var = var(:);
switch size(var, 1)
    
    case node
        
        
    case nele
        var = f_interp_cell2node(fgrid, var);
        
    otherwise
        error('The length of the 1st dimension is wrong.')
end



x1 = x(nv(:,1));
x2 = x(nv(:,2));
x3 = x(nv(:,3));
y1 = y(nv(:,1));
y2 = y(nv(:,2));
y3 = y(nv(:,3));
var1 = var(nv(:,1));
var2 = var(nv(:,2));
var3 = var(nv(:,3));


A = ( (x3-x1).*(y2-y1) - (x2-x1).*(y3-y1) ) /2;
dx = ((var1+var2)/2 .* (y1-y2) + ...
      (var2+var3)/2 .* (y2-y3) + ...
      (var3+var1)/2 .* (y3-y1))./A;
dy = ((var1+var2)/2 .* (x2-x1) + ...
      (var2+var3)/2 .* (x3-x2) + ...
      (var3+var1)/2 .* (x1-x3))./A;




% node = fgrid.node;
% nele = fgrid.nele;
% nbe = fgrid.nbe;
% 
% var = var(:);
% switch size(var, 1)
%     
%     case node
%         var = f_interp_node2cell(fgrid, var);
%         
%     case nele
%         
%         
%     otherwise
%         error('The length of the 1st dimension is wrong.')
% end
% 
% 
% [a1u, a2u] = f_calc_shape_coef2(fgrid);
% 
% var = [var; 0];
% 
% % Calculate vort on cell
% n1 = nbe(:,1);
% n2 = nbe(:,2);
% n3 = nbe(:,3);
% 
% dx = a1u(:,1).*var(1:nele) + a1u(:,2).*var(n1) + a1u(:,3).*var(n2) + a1u(:,4).*var(n3);
% dy = a2u(:,1).*var(1:nele) + a2u(:,2).*var(n1) + a2u(:,3).*var(n2) + a2u(:,4).*var(n3);
