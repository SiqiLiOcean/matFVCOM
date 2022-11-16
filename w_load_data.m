%==========================================================================
% Load data from WRF output (wrfout*)
%
% input  : 
%   --- fwrf
%   --- varname
%   --o start
%   --o count
% 
% output :
%   --- data
% 
% Siqi Li, SMAST
% 2021-07-01
%
% Updates:
% 2021-09-14  Siqi Li  Added 'RH2', 'Heat Flux'
% 2021-09-15  Siqi Li  Added 'RVO10'
%==========================================================================
function data = w_load_data(fwrf, varname, varargin)

FOUND = nc_if_varname(fwrf, varname);

if FOUND
    data = double(ncread(fwrf, varname, varargin{:}));
    
    varunit = nc_get_varunit(fwrf, varname);
    
    switch varunit
        case 'K'        % Kevin -> degree C
            data = data - 273.15;
        case 'Pa'       % Pa -> hPa
            data = data / 100;
    end
    
elseif strcmpi(varname, 'Potential Temperature')
    % Potential Temperature = perturbation potential temperature (theta-t0) + 300
    % Output unit: degree C
    T = w_load_data(fwrf, 'T', varargin{:});
    data = T + 300;   % Unit : Kevin -> degree C
    
elseif strcmpi(varname, 'Temperature')
    % Temperature = potential temperature * (pressure/p0)^kappa
    % Output unit: degree C
    pt = w_load_data(fwrf, 'Potential Temperature', varargin{:});
    pres = w_load_data(fwrf, 'Pressure', varargin{:});
    data = calc_tc(pt, pres);

elseif strcmpi(varname, 'Geopotential')
    % Geopotential = base-state geopotential + perturbation geopotential
    % Output unit: m2 s-2
    if isempty(varargin)
        nt = Inf;
    else
        nt = varargin{2}(4);
    end
    PH = w_load_data(fwrf, 'PH', varargin{:});
    PHB = w_load_data(fwrf, 'PHB', varargin{:});
    data = PH + PHB;
    if nt == 1
        data = ( data(:,:,1:end-1) + data(:,:,2:end) ) /2;
    else
        data = ( data(:,:,1:end-1,:) + data(:,:,2:end,:) ) /2;
    end
    
elseif strcmpi(varname, 'Pressure')
    % Geopotential = base-state geopotential + perturbation geopotential
    % Output unit: hPa
    P = w_load_data(fwrf, 'P', varargin{:});
    PB = w_load_data(fwrf, 'PB', varargin{:});
    data = P + PB;

elseif strcmpi(varname, 'Density')
    % density = 1 / (inverse base density + inverse perturbation density)
    % Output unit: kg m-3
    AL = w_load_data(fwrf, 'AL', varargin{:});
    ALB = w_load_data(fwrf, 'ALB', varargin{:});
    data = 1 / (AL + ALB);
    
elseif strcmpi(varname, 'SLP')   
    if ~isempty(varargin)
        if length(varargin{1}) > 3
            error('The SLP dimension should be [x, y, time]')
        end
        start_4 = [varargin{1}(1) varargin{1}(2) 1 varargin{1}(3)];
        count_4 = [varargin{2}(1) varargin{2}(2) Inf varargin{2}(3)];
    else
        start_4 = [1 1 1 1];
        count_4 = [Inf Inf Inf Inf];
    end
        
    T = w_load_data(fwrf, 'T', start_4, count_4);
    QVAPOR = w_load_data(fwrf, 'QVAPOR', start_4, count_4);
    pres = w_load_data(fwrf, 'Pressure', start_4, count_4);
    gp = w_load_data(fwrf, 'Geopotential', start_4, count_4);
    data = calc_slp(T, QVAPOR, pres, gp);
    
elseif strcmpi(varname, 'RH2')
    if ~isempty(varargin)
        if length(varargin{1}) > 3
            error('The RH2 dimension should be [x, y, time]')
        end
        start_3 = [varargin{1}(1) varargin{1}(2) varargin{1}(3)];
        count_3 = [varargin{2}(1) varargin{2}(2) varargin{2}(3)];
    else
        start_3 = [1 1 1];
        count_3 = [Inf Inf Inf];
    end    
    T2 = w_load_data(fwrf, 'T2', start_3, count_3) + 273.15;
    PSFC = w_load_data(fwrf, 'PSFC', start_3, count_3) * 100;
    Q2 = w_load_data(fwrf, 'Q2', start_3, count_3);
    data = calc_rh2(T2, PSFC, Q2);
    
elseif strcmpi(varname, 'Heat Flux')
    if ~isempty(varargin)
        if length(varargin{1}) > 3
            error('The RH2 dimension should be [x, y, time]')
        end
        start_3 = [varargin{1}(1) varargin{1}(2) varargin{1}(3)];
        count_3 = [varargin{2}(1) varargin{2}(2) varargin{2}(3)];
    else
        start_3 = [1 1 1];
        count_3 = [Inf Inf Inf];
    end     
    
    U10 = w_load_data(fwrf, 'U10', start_3, count_3);
    V10 = w_load_data(fwrf, 'V10', start_3, count_3);
    WIND10 = calc_uv2wind(U10, V10);
    T2 = w_load_data(fwrf, 'T2', start_3, count_3);
    RH2 = w_load_data(fwrf, 'RH2', start_3, count_3);
    PSFC = w_load_data(fwrf, 'PSFC', start_3, count_3);
    SST = w_load_data(fwrf, 'SST', start_3, count_3);
    SWDOWN = w_load_data(fwrf, 'SWDOWN', start_3, count_3);
    GLW = w_load_data(fwrf, 'GLW', start_3, count_3);
    XLAT = w_load_data(fwrf, 'XLAT', start_3, count_3);

    data = calc_coare30(WIND10,10, T2,2, RH2,2, PSFC, SST, SWDOWN, GLW, XLAT, 600);

elseif strcmpi(varname, 'RVO10')
    if ~isempty(varargin)
        if length(varargin{1}) > 3
            error('The RVO10 dimension should be [x, y, time]')
        end
        start_3 = [varargin{1}(1) varargin{1}(2) varargin{1}(3)];
        count_3 = [varargin{2}(1) varargin{2}(2) varargin{2}(3)];
    else
        start_3 = [1 1 1];
        count_3 = [Inf Inf Inf];
    end

    U10 = w_load_data(fwrf, 'U10', start_3, count_3);
    V10 = w_load_data(fwrf, 'V10', start_3, count_3);
    dx = ncreadatt(fwrf, '/', 'DX');
    dy = ncreadatt(fwrf, '/', 'DX');
    for it = 1 : count_3(3)
        data(:,:,it) = calc_rvo(U10(:,:,it), V10(:,:,it), dx, dy);
    end
else
    error('Unknow variable name.')
end

end



function FOUND = nc_if_varname(finput, varname)

FOUND = 0;

% Open the file.
ncid = netcdf.open(finput,'NC_NOWRITE');
% Get the variable number
[~, numvars] = netcdf.inq(ncid);

for i = 0 : numvars-1
    
    varname_file = netcdf.inqVar(ncid, i);
    if strcmp(varname, varname_file)
        FOUND = 1;
        netcdf.close(ncid);
        return
    end
    
end

% Close the file.
netcdf.close(ncid);

end
    
function varunit = nc_get_varunit(finput, varname)

    varunit = ncreadatt(finput, varname, 'units');
    
end
    
