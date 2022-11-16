%==========================================================================
% Calculate the shape coefficients u1a, u2a
% input  : 
%   fgrid
% 
% output : 
%   a1u
%   a2u
%
% Siqi Li, SMAST
% 2021-07-17
%
% Updates:
%
%==========================================================================
function [a1u, a2u] = f_calc_shape_coef2(fgrid)

nele = fgrid.nele;
xc = fgrid.xc;
yc = fgrid.yc;
nbe = fgrid.nbe;
nv = fgrid.nv;

% Calculate isonb and isbce
isonb = [fgrid.bdy{:}];
isbce = sum(ismember(nv, isonb), 2)>0;

% Calculate a1u and a2u
k = find(isbce==0);

x1 = xc(nbe(k,1)) - xc(k);
x2 = xc(nbe(k,2)) - xc(k);
x3 = xc(nbe(k,3)) - xc(k);
y1 = yc(nbe(k,1)) - yc(k);
y2 = yc(nbe(k,2)) - yc(k);
y3 = yc(nbe(k,3)) - yc(k);

delt = (x1.*y2-x2.*y1).^2 + (x1.*y3-x3.*y1).^2 + (x2.*y3-x3.*y2).^2 ;
% delt = delt*1000;

c0 = x1.*y1 + x2.*y2 + x3.*y3;
c1 = x1.*x1 + x2.*x2 + x3.*x3;
c2 = y1.*y1 + y2.*y2 + y3.*y3;

a1u = zeros(nele, 4);
a2u = zeros(nele, 4);

a1u(k, 1) = ( (y1+y2+y3).*c0 - (x1+x2+x3).*c2 ) ./ delt;
a1u(k, 2) = (        -y1.*c0 +         x1.*c2 ) ./ delt;
a1u(k, 3) = (        -y2.*c0 +         x2.*c2 ) ./ delt;
a1u(k, 4) = (        -y3.*c0 +         x3.*c2 ) ./ delt;

a2u(k, 1) = ( (x1+x2+x3).*c0 - (y1+y2+y3).*c1 ) ./ delt;
a2u(k, 2) = (        -x1.*c0 +         y1.*c1 ) ./ delt;
a2u(k, 3) = (        -x2.*c0 +         y2.*c1 ) ./ delt;
a2u(k, 4) = (        -x3.*c0 +         y3.*c1 ) ./ delt;



% % nele = fgrid.nele;
% % xc = [fgrid.xc; 0];
% % yc = [fgrid.yc; 0];
% % nbe = fgrid.nbe;
% % 
% % x1 = xc(nbe(:,1)) - xc(1:nele);
% % x2 = xc(nbe(:,2)) - xc(1:nele);
% % x3 = xc(nbe(:,3)) - xc(1:nele);
% % 
% % y1 = yc(nbe(:,1)) - yc(1:nele);
% % y2 = yc(nbe(:,2)) - yc(1:nele);
% % y3 = yc(nbe(:,3)) - yc(1:nele);
% % 
% % % Four variables used frequently
% % delt = (x1.*y2 - x2.*y1).^2 + (x1.*y3 - x3.*y1).^2 + (x2.*y3 - x3.*y2).^2;
% % tmp1 = x1.*y1 + x2.*y2 + x3.*y3;
% % tmp2 = x1.*x1 + x2.*x2 + x3.*x3;
% % tmp3 = y1.*y1 + y2.*y2 + y3.*y3;
% % 
% % % a1u
% % a1u(:,1) = (y1 + y2 + y3) .* tmp1 - (x1 + x2 + x3) .* tmp3;
% % a1u(:,2) = tmp3 .* x1 - tmp1 .* y1;        
% % a1u(:,3) = tmp3 .* x2 - tmp1 .* y2;    
% % a1u(:,4) = tmp3 .* x3 - tmp1 .* y3;          
% % a1u = a1u ./ delt;
% % 
% % 
% % % a2u
% % a2u(:,1) = (x1 + x2 + x3) .* tmp1 - (y1 + y2 + y3) .* tmp2;
% % a2u(:,2) = tmp2 .* y1 - tmp1 .* x1;        
% % a2u(:,3) = tmp2 .* y2 - tmp1 .* x2;    
% % a2u(:,4) = tmp2 .* y3 - tmp1 .* x3;          
% % a2u = a2u ./ delt;
% % 
% % 
% % [a, ~] = find(nbe==nele+1);
% % 
% % a1u(a,:) = 0;
% % a2u(a,:) = 0;
% % 
% % a1u(nele+1, :) = 0;
% % a2u(nele+1, :) = 0;
