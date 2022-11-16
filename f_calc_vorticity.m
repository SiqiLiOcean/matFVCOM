%==========================================================================
% Calculate vorticity of FVCOM grid
%
% input  : 
%   fgrid --- 
%   u ---
%   v ---
% 
% output : vort
%
% Siqi Li, SMAST
% 2021-09-13
%
% Updates:
%
%==========================================================================
function vort = f_calc_vorticity(fgrid, u, v)


% [dvdx, ~] = f_calc_gradient(fgrid, v);
% [~, dudy] = f_calc_gradient(fgrid, u);
% 
% vort = dvdx - dudy;

nele = fgrid.nele;
xc = fgrid.xc;
yc = fgrid.yc;
nbe = fgrid.nbe;
nv = fgrid.nv;

u = [u; 0];
v = [v; 0];

[a1u, a2u] = f_calc_shape_coef2(fgrid);

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

% Calculate vort on cell
n1 = nbe(:,1);
n2 = nbe(:,2);
n3 = nbe(:,3);

dvdx = a1u(:,1).*v(1:nele) + a1u(:,2).*v(n1) + a1u(:,3).*v(n2) + a1u(:,4).*v(n3);
dudy = a2u(:,1).*u(1:nele) + a2u(:,2).*u(n1) + a2u(:,3).*u(n2) + a2u(:,4).*u(n3);

vort1 = dvdx - dudy;

% Interpolate vort from cell to node
vort = f_interp_cell2node(fgrid, vort1);

