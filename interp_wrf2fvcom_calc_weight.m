%==========================================================================
% matFVCOM package
%   interp WRF-grid variables to FVCOM-grid ones (calculate weights)
%
% input  :
%   w
%   f
%   type
% 
% output :
%   weight
%
% Siqi Li, SMAST
% 2023-09-16
%
% Updates:
%
%==========================================================================
function weight = interp_wrf2fvcom_calc_weight(w, f, type, varargin)


if isstruct(w)
    w = {w};
end


ndomain = length(w);

if strcmpi(type, 'node')
    dst_x = f.x;
    dst_y = f.y;
    n = f.node;
elseif strcmpi(type, 'cell')
    dst_x = f.xc;
    dst_y = f.yc;
    n = f.nele;
else
    error('Unknown type.')
end

% Check if all FVCOM nodes are in the WRF grids
disp('Checking whether all the points are located in the domain(s):')
idm = zeros(n, 1);
unfound = 1 : n;
for i = ndomain : -1 : 1
    if strcmpi(w{i}.type, 'Global')
        idm(unfound) = i;
    else
        in = inpolygon(dst_x(unfound), dst_y(unfound), w{i}.bdy_x, w{i}.bdy_y);
        idm(unfound(in)) = i;
    end
    nfound = sum(idm==i);
    disp(['---Domain ' num2str(i) ': ' num2str(nfound, '%7.7d') '  (' num2str(nfound/n*100, '%5.2f') '%)'])
    unfound = find(idm==0);
end
if ~isempty(unfound)
    disp(['There are totally ' sum(unfound) ' FVCOM nodes out of domains.'])
    disp('The extrapolation of the 1st WRF domain will be applied.')
end

% Calculate the weight.
disp('Calculate the weight matrix')
for i = 1 : ndomain
    disp(['    Domain ' num2str(i)])
    id = find(idm==i);
    weight{i}.id = id;
    if strcmpi(w{i}.type, 'Global')
        weight{i}.w = interp_2d_calc_weight('GLOBAL_BI', w{i}.x(:,1), w{i}.y(1,:)', dst_x(id), dst_y(id));
    else
        weight{i}.w = interp_2d_calc_weight('QU', w{i}.x, w{i}.y, dst_x(id), dst_y(id));
    end
end