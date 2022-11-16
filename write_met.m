%==========================================================================
% Write horizontal diffusion coefficient NetCDF file
% 
% Input  : --- fhvc, hvc file path and name
%          --- nn_hvc, horizontal diffusion coefficient on node
%          --- cc_hvc, horizontal diffusion coefficient on cell
%
% Output : \
% 
% Usage  : write_met(fheat, , )
%
% v1.0
%
% Siqi Li
% 2021-11-30
%
% Updates:
%
%==========================================================================
function write_met(fmet, grid, time, var_name, var)

if ~iscell(var_name)
    var_name = {var_name};
    var = {var};
end


cell_var_list = {'UWIND_SPEED', 'U10', ...
                 'VWIND_SPEED', 'V10', ...
                 'UWIND_STRESS', 'STRESS_U', ...
                 'VWIND_STRESS', 'STRESS_V'};


if isfield(grid, 'nv')
    disp('The grid is FVCOM')
    grid_type = 'FVCOM';
else
    disp('The grid is WRF / MM5')
    grid_type = 'WRF';
    error('Unsopported so far.')
end



% Itime = floor(time);
% Itime2 = (time -Itime) * 24 * 3600 * 1000;



switch grid_type
    
    case 'FVCOM'
        
        node = grid.node;
        nele = grid.nele;
        nv = grid.nv;
        nt = length(time);
        three = 3;
        
        
        % create the output file.
        ncid=netcdf.create(fmet, 'CLOBBER');
        
        %define the dimension
        node_dimid = netcdf.defDim(ncid, 'node', node);
        nele_dimid = netcdf.defDim(ncid, 'nele', nele);
        three_dimid = netcdf.defDim(ncid, 'three', 3);
        time_dimid = netcdf.defDim(ncid, 'time', netcdf.getConstant('NC_UNLIMITED'));
        
        % Define variables
%         x_varid = netcdf.defVar(ncid, 'x', 'float', node_dimid);
%         y_varid = netcdf.defVar(ncid, 'y', 'float', node_dimid);
%         lon_varid = netcdf.defVar(ncid, 'lon', 'float', node_dimid);
%         lat_varid = netcdf.defVar(ncid, 'lat', 'float', node_dimid);
%         nv_varid = netcdf.defVar(ncid, 'nv', 'float', [nele_dimid three_dimid]);
        time_varid = netcdf.defVar(ncid, 'time', 'float', time_dimid);
%         Itime_varid = netcdf.defVar(ncid, 'Itime', 'float', time_dimid);
%         Itime2_varid = netcdf.defVar(ncid, 'Itime2', 'float', time_dimid);
        
        
        % Write global attribute
        netcdf.putAtt(ncid, netcdf.getConstant('NC_GLOBAL'), 'source', 'FVCOM grid (unstructured) surface forcing');
        
        % Write variable attributes
        netcdf.putAtt(ncid, time_varid, 'units', 'days since 0.0');
        netcdf.putAtt(ncid, time_varid, 'time_zone', 'none');
        
        for iv = 1 : length(var_name)
            if ismember(upper(var_name{iv}), cell_var_list)
                dimids = [nele_dimid time_dimid];
            else
                dimids = [node_dimid time_dimid];
            end
            varid(iv) = def_variable(ncid, var_name{iv}, dimids);
        end
        
        %end define mode
        netcdf.endDef(ncid);
        
        % Write data
        for it = 1 : nt
            
            netcdf.putVar(ncid, time_varid, it-1, 1, time(it));
%             netcdf.putVar(ncid, Itime_varid, it-1, 1, Itime(it));
%             netcdf.putVar(ncid, Itime2_varid, it-1, 1, Itime2(it));
            
            
            for iv = 1 : length(var_name)
                if ismember(upper(var_name{iv}), cell_var_list)
                    netcdf.putVar(ncid, varid(iv), [0 it-1], [nele 1], var{iv}(:,it));
                else
                    netcdf.putVar(ncid, varid(iv), [0 it-1], [node 1], var{iv}(:,it));
                end
            end
        end
        
        % close NC file
        netcdf.close(ncid)

    case 'WRF'
        
end



end


function varid = def_variable(ncid, varname, dimid)

switch upper(varname)
    
    %
    case {'SLP', 'AIR_PRESSURE', 'PRESSURE_AIR'}
        varid = netcdf.defVar(ncid, 'air_pressure', 'float', dimid);
        netcdf.putAtt(ncid, varid, 'long_name', 'Air Pressure');
        netcdf.putAtt(ncid, varid, 'unit', 'Pa');
      
    %
    case {'UWIND_SPEED', 'U10'}
        varid = netcdf.defVar(ncid, 'uwind_speed', 'float', dimid);
        netcdf.putAtt(ncid, varid, 'long_name', 'Northward Wind Speed');
        netcdf.putAtt(ncid, varid, 'unit', 'm/s');
        
    case {'VWIND_SPEED', 'V10'}
        varid = netcdf.defVar(ncid, 'vwind_speed', 'float', dimid);
        netcdf.putAtt(ncid, varid, 'long_name', 'Eastward Wind Speed');
        netcdf.putAtt(ncid, varid, 'unit', 'm/s');

    case {'UWIND_STRESS', 'STRESS_U'}
        varid = netcdf.defVar(ncid, 'uwind_stress', 'float', dimid);
        netcdf.putAtt(ncid, varid, 'long_name', 'Northward Wind Stress');
        netcdf.putAtt(ncid, varid, 'unit', 'Pa');
        
    case {'VWIND_STRESS', 'STRESS_V'}
        varid = netcdf.defVar(ncid, 'vwind_stress', 'float', dimid);
        netcdf.putAtt(ncid, varid, 'long_name', 'Eastward Wind Stress');
        netcdf.putAtt(ncid, varid, 'unit', 'Pa');
    %        
    case {'NET_HEAT_FLUX', 'NET_HEAT'} 
        varid = netcdf.defVar(ncid, 'net_heat_flux', 'float', dimid);
        netcdf.putAtt(ncid, varid, 'long_name', 'Surface Net Heat Flux');
        netcdf.putAtt(ncid, varid, 'unit', 'W m-2');
        
    case {'SHORT_WAVE', 'SHORTWAVE'}
        varid = netcdf.defVar(ncid, 'short_wave', 'float', dimid);
        netcdf.putAtt(ncid, varid, 'long_name', 'Short Wave Radiation');
        netcdf.putAtt(ncid, varid, 'unit', 'W m-2');
        
    %     
    case {'PRECIPITATION'}
        Pricipitation
        varid = netcdf.defVar(ncid, 'Precipitation', 'float', dimid);
        netcdf.putAtt(ncid, varid, 'long_name', 'Precipitation, negative when ocean loses water');
        netcdf.putAtt(ncid, varid, 'unit', 'm/s');
        
    case {'EVAPORATION'}
        Evaporation
        varid = netcdf.defVar(ncid, 'Evaporation', 'float', dimid);
        netcdf.putAtt(ncid, varid, 'long_name', 'Evaporation, negative when ocean loses water');
        netcdf.putAtt(ncid, varid, 'unit', 'm/s');
        
    otherwise
        error([Unknown variable name : varname])
end
        
        
        
        
end
        
        
        