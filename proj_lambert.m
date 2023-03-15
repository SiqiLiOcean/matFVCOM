%==========================================================================
% Lambert Projection: ij2ll
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
%                      truelat2   : true latitude 2 (degree N)
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
function [lon, lat] = proj_lambert(proj)

% Read the input parameters of Lambert Projection (Two styles)
if isfield(proj, 'share') && isfield(proj, 'geogrid')    % WPS style
    struct_extract(proj.share, "max_dom");
    struct_extract(proj.geogrid, ["dx", "ref_lat", "ref_lon",         ...
                                 "i_parent_start", "j_parent_start",  ...
                                 "s_we", "s_sn", "e_we", "e_sn",      ...
                                 "parent_grid_ratio", "parent_id",    ...
                                 "truelat1", "truelat2", "stand_lon"]);
else                                                     % Simple style
    struct_extract(proj, ["dx", "ref_lat", "ref_lon", "e_we", "e_sn", ...
                          "truelat1", "truelat2", "stand_lon"]);
    i_parent_start = 1;
    j_parent_start = 1;
    s_we = 1;
    s_sn = 1;
    parent_grid_ratio = 1;
    parent_id = 1;
    max_dom = 1;
end
    
    
% parent_id = [1 1];
% dx = 30e3;
% dy = 30e3;
% truelat1 = 30;
% truelat2 = 60;
% ref_lat = 34.83;
% ref_lon = -81.03;
% stand_lon = -98.;
% i_parent_start = [1, 31];
% j_parent_start = [1, 17];
% s_we = [1,1];
% s_sn = [1,1];
% e_we = [74, 112];
% e_sn = [61, 97];
% parent_grid_ratio = [1, 3];


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

% -----From lc_cone, module_map_utils.F, WPS-----
% Compute cone factor 
if (abs(truelat1-truelat2) > 0.1)
    val1 = log10( cos( truelat1*rad_per_deg ) ) - ...
           log10( cos( truelat2*rad_per_deg ) );
    val2 = log10( tan( (45-abs(truelat1)/2) * rad_per_deg ) ) - ...
           log10( tan( (45-abs(truelat2)/2) * rad_per_deg ) );
    cone = val1 / val2;
else
    cone = sin( abs(truelat1)*rad_per_deg );
end


% -----From set_lc, module_map_utils.F, WPS-----
% Compute logitude differences and ensure we stay out of the forbidden "cut
% zone"
deltalon1 = ref_lon  - stand_lon;
deltalon1 = mod(deltalon1+180, 360) - 180;

% Convert truelat1 to radian and compute COS for later use
tl1r = truelat1 * rad_per_deg;
ctl1r = cos(tl1r);

% Compute the radius to our know lower-left (SW) coner
val1 = tan( (90*hemi - ref_lat )/2 * rad_per_deg ) / ...
       tan( (90*hemi - truelat1)/2 * rad_per_deg );
rsw = rebydx * ctl1r/cone * val1^cone;

% Find pole point
arg = cone * (deltalon1 * rad_per_deg);
polei = hemi*known_i(1) - hemi*rsw * sin(arg);
polej = hemi*known_j(1) + rsw * cos(arg);

% -----From ijll_lc, module_map_utils.F, WPS-----
chi1 = (90 - hemi*truelat1) * rad_per_deg;
chi2 = (90 - hemi*truelat2) * rad_per_deg;


for idm = 1 : max_dom
    
current_dm = idm;
    
i = s_we(idm) : e_we(idm)-1;
j = s_sn(idm) : e_sn(idm)-1;

while current_dm>1    
    i = i_parent_start(current_dm) + (i-2)/parent_grid_ratio(current_dm);
    j = j_parent_start(current_dm) + (j-2)/parent_grid_ratio(current_dm);
    
    current_dm = parent_id(current_dm);
end
    
[jj, ii] = meshgrid(j, i);



% -----From ijll_lc, module_map_utils.F, WPS-----
% Set if we are in the southern hempispere and flip the indices if we are.
inew = hemi * ii;
jnew = hemi * jj;

% Compute radius^2 to i/j location
xx = inew - polei;
yy = polej - jnew;
r2 = xx.*xx + yy.*yy;
r = sqrt(r2) / rebydx;

% Convert j/j to lon/lat
lon{idm} = stand_lon + deg_per_rad * atan2(hemi*xx, yy)/cone;
lon{idm} = mod(lon{idm}+360, 360);

if truelat1 == truelat2
    chi = 2*atan( (r/tan(chi1))^(1/cone) * tan(chi1*.5) );
else
    chi = 2*atan( (r*cone/sin(chi1)).^(1/cone) * tan(chi1*.5) );
end
lat{idm} = (90 - chi*deg_per_rad)*hemi;

k_pole = r2==0;
lon{idm}(k_pole) = hemi * 90;
lat{idm}(k_pole) = stand_lon;
% if (r2 == 0.)
%     lat = hemi * 90;
%     lon = stand_lon;
% else
%     lon = stand_lon + deg_per_rad * atan2(hemi*xx, yy)/cone;
%     lon = mod(lon+360, 360);
%     
%     if truelat1 == truelat2
%         chi = 2*atan( (r/tan(chi1))^(1/cone) * tan(chi1*.5) );
%     else
%         chi = 2*atan( (r*cone/sin(chi1))^(1/cone) * tan(chi1*.5) );
%     end
%     lat = (90 - chi*deg_per_rad)*hemi;
% end

lon{idm} = mod(lon{idm}+180, 360) - 180;

end