%==========================================================================
% Polar Projection: ij2ll
%
% input  :
%   proj --- Option 1: read namelist.wps by read_nml_wps (support nesting)
%            Option 2: set manually, containning the followings (1 domain):
%                      ----
%                      dx         : grid size (m)
%                      ref_lat    : referenced/central latitude (degree N)
%                      ref_lon    : referenced/central latitude (degree N)
%                      e_we       : x-dimension length
%                      e_sn       : y-dimension length
%                      ----
%                      truelat1   : true latitude 1 (degree N)
%                      stand_lon  : standard longitude 
%
% output :
%   lon --- longitude
%   lat --- latitude
%
% Siqi Li, SMAST
% 2022-03-18
%
% Updates:
%
%==========================================================================
function [lon, lat] = proj_polar(proj)

% Read the input parameters of Lambert Projection (Two styles)
if isfield(proj, 'share') && isfield(proj, 'geogrid')    % WPS style
    struct_extract(proj.share, "max_dom");
    struct_extract(proj.geogrid, ["dx", "ref_lat", "ref_lon",         ...
                                 "i_parent_start", "j_parent_start",  ...
                                 "s_we", "s_sn", "e_we", "e_sn",      ...
                                 "parent_grid_ratio", "parent_id",    ...
                                 "truelat1", "stand_lon"]);
else                                                     % Simple style
    struct_extract(proj, ["dx", "ref_lat", "ref_lon", "e_we", "e_sn", ...
                          "truelat1", "stand_lon"]);
    i_parent_start = 1;
    j_parent_start = 1;
    s_we = 1;
    s_sn = 1;
    parent_grid_ratio = 1;
    parent_id = 1;
    max_dom = 1;
end


%-----Parameters-----
rad_per_deg = pi / 180;
deg_per_rad = 180 / pi;
re_m = 6370e3;              % Earth radius (m)

%-----From map_set, module_map_utils.F, WPS-----
if truelat1 <0
    hemi = -1;
else
    hemi = 1;
end
rebydx = re_m / dx;

%-----From get_grid_params, gridinfo_module.F, WPS-----
ixdim = e_we - s_we + 1;
jydim = e_sn - s_sn + 1;
known_i = ixdim / 2;
known_j = jydim / 2;


% -----From set_ps, module_map_utils.F, WPS-----
% Initialize a polar-stereographic map projection from the partially filled
% proj structure. This routine computes the radius to the southwest corner
% and computes the i/j location of the pole.

% Compute the reference longitude by rotating 90 degrees to the east to
% find the longitude line parallel to the positive x-axis
reflon = stand_lon + 90;

% Compute numerator term of map scale factor
scale_top = 1 + hemi*sin(truelat1*rad_per_deg);

% Compute radius to lower-left (SW) corner
ala1 = ref_lat * rad_per_deg;
rsw = ( rebydx*cos(ala1)*scale_top ) / (1+hemi*sin(ala1));

% Find the pole point
alo1 = (ref_lon-reflon) * rad_per_deg;
pole_i = known_i(1) - rsw*cos(alo1);
pole_j = known_j(1) - hemi*rsw*sin(alo1);


for idm = 1 : max_dom
    
current_dm = idm;
    
i = s_we(idm) : e_we(idm)-1;
j = s_sn(idm) : e_sn(idm)-1;

while current_dm>1    
    i = i_parent_start(idm) + (i-2)/parent_grid_ratio(idm);
    j = j_parent_start(idm) + (j-2)/parent_grid_ratio(idm);
    
    current_dm = parent_id(idm);
end
    
[jj, ii] = meshgrid(j, i);

% -----From ijll_ps, module_map_utils.F, WPS-----
% Compute radius to point of interest
xx = ii - pole_i;
yy = (jj - pole_j) * hemi;
r2 = xx.^2 + yy.^2;

gi2 = (rebydx*scale_top)^2;
lat{idm} = deg_per_rad * hemi * asin( (gi2-r2) ./ (gi2+r2) );
arccos = acos( min( max(xx./sqrt(max(r2,1e-4)), -1), 1) );
lon{idm} = reflon + sign(yy).*arccos*deg_per_rad;

k_pole = r2==0;
lon{idm}(k_pole) = hemi * 90;
lat{idm}(k_pole) = reflon;

lon{idm} = mod(lon{idm}+180, 360) - 180;

end