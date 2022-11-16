%==========================================================================
% Calculate vorticity within a polygon from its velocity
%
% input  :
%   px --- polygon x
%   py --- polygon y
%   pu --- polygon u
%   pv --- polygon v
% 
% output :
%   Vort --- vorticity
%
% Siqi Li, SMAST
% 2022-07-27
%
% Updates:
%
%==========================================================================
function Vort = calc_polygon_vorticity(px, py, pu, pv, varargin)

varargin = read_varargin(varargin, {'R'}, {6371e3});
varargin = read_varargin2(varargin, {'Geo'});


if px(1)~=px(end) && py(1)~=py(end)
    px(end+1) = px(1);
    py(end+1) = py(1);
    pu(end+1) = pu(1);
    pv(end+1) = pv(1);
end

% mx = (px(1:end-1) + px(2:end)) / 2;
% my = (py(1:end-1) + py(2:end)) / 2;
mu = (pu(1:end-1) + pu(2:end)) / 2;
mv = (pv(1:end-1) + pv(2:end)) / 2;

for i = 1 : length(mu)
    projV(i) = calc_proj_vector([px(i+1)-px(i) py(i+1)-py(i)], [mu(i) mv(i)]);
    len(i) = calc_distance(px(i), py(i), px(i+1), py(i+1), 'R', R, Geo);
end
    
S = calc_area(px, py, 'R', R, Geo);


Vort = projV(:)'*len(:) / S;




