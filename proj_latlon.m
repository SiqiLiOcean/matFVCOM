%==========================================================================
% Lat-lon/Cassini Projection: ij2ll
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
%                      stand_lon  : standard longitude 
%                      pole_lon   : the latitude of the North Pole with 
%                                   respect to the computational 
%                                   latitude-longitude grid in which 
%                                   -90.0° latitude is at the bottom of a 
%                                   global domain, 90.0° latitude is at the
%                                   top, and 180.0° longitude is at the 
%                                   center. 
%                      pole_lat   : (see pole_lon)
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
function [lon, lat] = proj_latlon(proj)

% Read the input parameters of Lambert Projection (Two styles)
if isfield(proj, 'share') && isfield(proj, 'geogrid')    % WPS style
    struct_extract(proj.share, "max_dom");
    struct_extract(proj.geogrid, ["dx", "ref_lat", "ref_lon",         ...
                                 "i_parent_start", "j_parent_start",  ...
                                 "s_we", "s_sn", "e_we", "e_sn",      ...
                                 "parent_grid_ratio", "parent_id",    ...
                                 "stand_lon", "pole_lon", "pole_lat"]);
else                                                     % Simple style
    struct_extract(proj, ["dx", "ref_lat", "ref_lon", "e_we", "e_sn", ...
                          "stand_lon", "pole_lon", "pole_lat"]);
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

% % % %-----From map_set, module_map_utils.F, WPS-----
% % % if truelat1 <0
% % %     hemi = -1;
% % % else
% % %     hemi = 1;
% % % end
% % % rebydx = re_m / dx;

% -----From get_grid_params, gridinfo_module.F, WPS-----
if isnan(dx)
    dlondeg = 360 / (e_we(1) - s_we(1));
    dlatdeg = 180 / (e_sn(1) - s_sn(1));
    dxkm = re_m * pi * 2 / (e_we(1) - s_we(1));
    dykm = re_m * pi     / (e_sn(1) - s_sn(1));
    known_lon = stand_lon + dlondeg/2;
    known_lat = -90 + dlatdeg/2;
    known_i = 1;
    known_j = 1;

else
    dlondeg = dx;
    dlatdeg = dy;
    dxkm = dlondeg * re_m * pi * 2 /360;
    dykm = dlatdeg * re_m * pi * 2 /360;
    known_lon = ref_lon;
    known_lat = ref_lat;
    if isnan(known_lon) || isnan(known_lat)
        error(['For lat-lon projection, if dx/dy are specified, a '  ...
               'regional domain is assumed, and a ref_lon, ref_lat ' ...
               'must also be specified.'])
    end
end

% % % -----From get_grid_params, gridinfo_module.F, WPS-----
% % ixdim = e_we - s_we + 1;
% % jydim = e_sn - s_sn + 1;
% % known_i = ixdim / 2;
% % known_j = jydim / 2;





% -----From set_cassini, module_map_utils.F, WPS-----
hemi = 1;
loninc = dlondeg;
latinc = dlatdeg;
dx = dxkm;
dy = dykm;
lon0 = pole_lon;
lat0 = pole_lat;
lon1 = known_lon;
lat1 = known_lat; 

if abs(lat1 - latinc/2 + 90)<1e-3 && ...
   abs( mod(lon1 - loninc/2 - stand_lon, 360) )<1e-3
    global_domain = true;
else
    global_domain = false;
end

if abs(lat0)~=90 && ~global_domain
    [comp_lat, comp_lon] = rotate_coords(lat1, lon1, lat0, lon0, stand_lon, -1);
    comp_lon = comp_lon + stand_lon;
    lat1 = comp_lat;
    lon1 = comp_lon;
end


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

% -----From ijll_cassini, module_map_utils.F, WPS-----
% Convert i/j to computational lon/lat (ijll_cyl)
i_work = ii - known_i;
j_work = jj - known_j;
k1 = i_work<0;
k2 = i_work>360/loninc;
i_work(k1) = i_work(k1) + 360/loninc;
i_work(k2) = i_work(k2) - 360/loninc;
comp_lon = i_work * loninc + lon1;
comp_lat = j_work * latinc + lat1;
comp_lon = mod(comp_lon+180, 360) - 180;

% Convert computational to geographic lon/lat
comp_ll = true;
if abs(lat0)~=90 && ~comp_ll
    comp_lon = comp_lon - stand_lon;
    [lat{idm}, lon{idm}] = rotate_coords(comp_lat, comp_lon, lat0, lon0, standlon, 1);
else
    lon{idm} = comp_lon;
    lat{idm} = comp_lat;
end


end

end

%--------------------------------------------------------------------------
% Converts between computational and geographic lat/lon for Cassini
% Orginal: rotate_coords, module_map_utils.F, WPS
% Siqi Li, SMAST
% 2022-03-28
%--------------------------------------------------------------------------

function [olat, olon] = rotate_coords(ilat, ilon, lat_np, lon_np, lon_0, direction)

rad_per_deg = pi / 180;
deg_per_rad = 180 / pi;

% Convert all angles to radians
phi_np = lat_np * rad_per_deg;
lam_np = lon_np * rad_per_deg;
lam_0 = lon_0 * rad_per_deg;
rlat = ilat * rad_per_deg;
rlon = ilon * rad_per_deg;

dlam = lam_np;
if nargin>5 && direction<0
    % The equations are exactly the same except for one small
    % difference with respect to longitude.
    dlam = pi - lam_0;
end

sinphi = cos(phi_np)*cos(rlat)*cos(rlon-dlam) + sin(phi_np)*sin(rlat);
cosphi = sqrt(1-sinphi*sinphi);
coslam = sin(phi_np)*cos(rlat)*cos(rlon-dlam) - cos(phi_np)*sin(rlat);
sinlam = cos(rlat)*sin(rlon-dlam);

if cosphi~=0
    coslam = coslam / cosphi;
    sinlam = sinlam / cosphi;
end

olat = deg_per_rad * asin(sinphi);
olon = deg_per_rad * (atan2(sinlam,coslam) -dlam - lam_0 + lam_np);

olon = mod(olon+180, 360) - 180;

end