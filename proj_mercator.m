%==========================================================================
% Mercator Projection: ij2ll
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
%
% output :
%   lon --- longitude
%   lat --- latitude
%
% Siqi Li, SMAST
% 2022-03-27
%
% Updates:
%
%==========================================================================
function [lon, lat] = proj_mercator(proj)

% Read the input parameters of Lambert Projection (Two styles)
if isfield(proj, 'share') && isfield(proj, 'geogrid')    % WPS style
    struct_extract(proj.share, "max_dom");
    struct_extract(proj.geogrid, ["dx", "ref_lat", "ref_lon",         ...
                                 "i_parent_start", "j_parent_start",  ...
                                 "s_we", "s_sn", "e_we", "e_sn",      ...
                                 "parent_grid_ratio", "parent_id",    ...
                                 "truelat1"]);
else                                                     % Simple style
    struct_extract(proj, ["dx", "ref_lat", "ref_lon", "e_we", "e_sn", ...
                          "truelat1"]);
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


%-----From get_grid_params, gridinfo_module.F, WPS-----
ixdim = e_we - s_we + 1;
jydim = e_sn - s_sn + 1;
known_i = ixdim / 2;
known_j = jydim / 2;


% -----From set_lc, module_map_utils.F, WPS-----
% Set up the remaining basic elements for the mercator projection
% Preliminary variables
clain = cos( rad_per_deg*truelat1 );
dlon = dx / (re_m*clain);

% Compute distance from equator to origin (rsw tag)
rsw = 0;
if (ref_lat ~= 0)
    rsw = log( tan( 0.5*(ref_lat+90)*rad_per_deg ) ) / dlon;
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


% -----From ijll_merc, module_map_utils.F, WPS-----
% Compute the lat/lon from i/j for mercator projection
lat{idm} = 2 * atan( exp( dlon*(rsw+jj-known_j(idm) ) ) ) * deg_per_rad - 90;
lon{idm} = (ii - known_i(idm))*dlon*deg_per_rad + ref_lon;


lon{idm} = mod(lon{idm}+180, 360) - 180;

end