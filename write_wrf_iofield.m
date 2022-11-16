%==========================================================================
% Create the iofield file of WRF
%
% input  :
%   fwrf --- wrfout file path and name
%   fio  --- output file of iofield file
%   vars --- string of variable list
% 
% output :
%   \
%
% Siqi Li, SMAST
% 2022-05-08
%
% Updates:
%
%==========================================================================
function write_wrf_iofield(fwrf, fio, vars)


% clc
% clear
% 
% fwrf = 'wrfout.nc';
% fio = 'output_climate2050.txt';
% 
% vars = ["XLONG";                                     % Coordinate-X
% %         "XLONG_U"; "XLONG_V";
%         "XLAT";                                      % Coordinate-Y
% %         "XLAT_U"; "XLAT_V"; 
%         "HGT";                                       % Coordinate-Z
%         "Times";                                     % Coordinate-time
%         "XLAND"; "LAKEMASK"; "LANDMASK"; "LU_INDEX"; % Mask
%         "PH"; "PHB";                                 % Geopotential
%         "P"; "PB"; "P00";                            % Pressure
%         "T"; "T00";                                  % Temperature
%         "QVAPOR";                                    % Water vapor
%         "AL"; "ALB";                                 % Inverse density
% %         "U"; "V"; "W"; "UST";                        % Velocity
%         "U10"; "V10"; "T2"; "TH2"; "Q2"; "PSFC";     % 
%         "SST"; "SSTSK"; "SST_INPUT"; "TSK";          % Surface temperature
%         "RAINC"; "RAINNC"; "I_RAINC"; "I_RAINNC";    % Precipitation
%         "ALBEDO"; "ALBBCK";                          % Albedo
%         "GLW"; "SWDOWN";                             % Heat flux
%         ];
%     
% Get the variable name list from a NetCDF WRF history output.
ncid = netcdf.open(fwrf);
% Get the variable number
[~,nvars] = netcdf.inq(ncid);
% Read the variable names
for i = 0 : nvars-1
    vars0(i+1,1) = convertCharsToStrings(netcdf.inqVar(ncid,i));
end
netcdf.close(ncid);

% Remove the duplicate variables
vars = unique(upper(vars));

n = length(vars);
n0 = length(vars0);

% Find the variables that are not included in the list now.
k_add = find(~ismember(upper(vars), upper(vars0)));
disp([num2str(length(k_add)) ' variables are added:'])
for i = 1 : length(k_add)
    fprintf('%s', vars0(k_add(i)));
    if mod(i,5)==0 || i==length(k_add)
        fprintf('\n');
    else
        fprintf('%s', ', ');
    end
end


% Find the variables that are not needed.
k_remove = find(~ismember(upper(vars0), upper(vars)));
disp([num2str(length(k_remove)) ' variables are removed:'])
for j = 1 : length(k_remove)
    fprintf('%s', vars0(k_remove(j)));
    if mod(j,5)==0 || j==length(k_remove)
        fprintf('\n');
    else
        fprintf('%s', ', ');
    end
end


fid = fopen(fio, 'w');
for i = 1 : length(k_add)
    fprintf(fid, '%s%s\n', '+:h:0:', vars(k_add(i)));
end
for j = 1 : length(k_remove)
    fprintf(fid, '%s%s\n', '-:h:0:', vars0(k_remove(j)));
end
fclose(fid);
    
    
