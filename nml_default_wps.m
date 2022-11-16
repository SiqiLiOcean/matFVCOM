%==========================================================================
%
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% yyyy-mm-dd
%
% Updates:
%
%==========================================================================
function nml = nml_default_wps(dm)

missing = 1e9;

if ~exist('dm', 'var')
    dm = 1;
end

nml.share.wrf_core                       = "ARW";
nml.share.max_dom                        = dm;
nml.share.start_date(1:dm)               = "0000-00-00_00:00:00";              
nml.share.end_date(1:dm)                 = 0; 
nml.share.start_year(1:dm)               = 0;
nml.share.end_year(1:dm)                 = 0;
nml.share.start_month(1:dm)              = 0;
nml.share.end_month(1:dm)                = 0;
nml.share.start_day(1:dm)                = 0;
nml.share.end_day(1:dm)                  = 0;
nml.share.start_hour(1:dm)               = 0;
nml.share.end_hour(1:dm)                 = 0;
nml.share.start_minute(1:dm)             = 0;
nml.share.end_minute(1:dm)               = 0;
nml.share.start_second(1:dm)             = 0;
nml.share.end_second(1:dm)               = 0;
nml.share.interval_seconds               = missing;
nml.share.io_form_geogrid                = 2;
nml.share.opt_output_from_geogrid_path   = "./";
nml.share.debug_level                    = 0;
nml.share.active_grid(1:dm)              = true;
nml.share.subgrid_ratio_x(1:dm)          = 1;
nml.share.subgrid_ratio_y(1:dm)          = 1;
nml.share.nocolons                       = false;

nml.geogrid.parent_id(1:dm)              = 1;
nml.geogrid.parent_grid_ratio(1:dm)      = missing;
nml.geogrid.i_parent_start(1:dm)         = 1;   % These should be with no default.
nml.geogrid.j_parent_start(1:dm)         = 1;   % These should be with no default.
nml.geogrid.s_we(1:dm)                   = 1;
nml.geogrid.e_we(1:dm)                   = missing;
nml.geogrid.s_sn(1:dm)                   = 1;
nml.geogrid.e_sn(1:dm)                   = missing;
nml.geogrid.map_proj                     = "Lambert";
nml.geogrid.ref_x                        = nan;
nml.geogrid.ref_y                        = nan;
nml.geogrid.ref_lat                      = nan;
nml.geogrid.ref_lon                      = nan;
nml.geogrid.pole_lat                     = 90.0;
nml.geogrid.pole_lon                     = 0.0;
nml.geogrid.truelat1                     = nan;
nml.geogrid.truelat2                     = nan;
nml.geogrid.stand_lon                    = nan;
nml.geogrid.dx                           = nan;
nml.geogrid.dy                           = nan;
nml.geogrid.geog_data_res(1:dm)          = "default";
nml.geogrid.geog_data_path               = "NOT_SPECIFIED";
nml.geogrid.opt_geogrid_tbl_path         = "geogrid/";

nml.ungrib.out_format                    = "WPS";
nml.ungrib.ordered_by_date               = true;
nml.ungrib.prefix                        = "FILE";
nml.ungrib.add_lvls                      = false;
nml.ungrib.new_plvl                      = -99999.0;
nml.ungrib.interp_type                   = 0;
nml.ungrib.ec_rec_len                    = 0;
nml.ungrib.pmin                          = 100.0;  % 1 hPa, ~48km

nml.metgrid.io_form_metgrid              = 2;
nml.metgrid.fg_name(1:dm)                = "*";
nml.metgrid.constants_name(1:dm)         = "*";
nml.metgrid.process_only_bdy             = 0;
nml.metgrid.opt_output_from_metgrid_path = "./";
nml.metgrid.opt_metgrid_tbl_path         = "metgrid/";

