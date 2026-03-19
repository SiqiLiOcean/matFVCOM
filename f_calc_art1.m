
%==========================================================================
% matFVCOM package
% 
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% 2026-03-18
%
% Updates:
%
%==========================================================================
function art1 = f_calc_art1(f)

x = f.x;
y = f.y;
nv = f.nv;
nbve = f.nbve;
area = calc_area(x(nv), y(nv));
area = [area; nan];

art1 = sum(area(nbve), 2, "omitnan") / 3;
