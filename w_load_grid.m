%==========================================================================
%  Load the WRF grid from WRF output
%
% Input  : --- fwrf, WRF output file path and name
%     (optional)
%     --- 'rotate', theta  (angle of rotate the (x,y), positive for anti-clockwise)
% Output : --- wgrid, WRF grid cell
%
% Usage  : wgrid = w_load_grid(fwrf);
%            OR
%          wgrid = w_load_grid(lon, lat);
%
% v1.0
%
% Siqi Li
% 2021-05-07
%
% Updates:
% 2021-06-20  Siqi Li  Added the function of rotating the (x,y)
% 2021-06-21  Siqi Li  Added nv, so that we can use it to patch.
% 2024-03-02  Chenyu Zhang  Added 'Global' option and fixed the longitude
%==========================================================================
function wgrid = w_load_grid(varargin)

varargin = read_varargin(varargin, {'MaxLon'}, {360});
varargin = read_varargin2(varargin, {'Global'});

wgrid.type = 'WRF';

G = 9.81;



varargin = read_varargin2(varargin, {'P', 'Z'});
nt = 1;
nz = 1;

switch class(varargin{1})
    case 'char'
        fwrf = varargin{1};
        
        if nc_Var_exist(fwrf, 'XLONG')
            x = double(ncread(fwrf, 'XLONG'));
            y = double(ncread(fwrf, 'XLAT'));
        elseif nc_Var_exist(fwrf, 'XLONG_M')
            x = double(ncread(fwrf, 'XLONG_M'));
            y = double(ncread(fwrf, 'XLAT_M'));
        end
            
        n1 = unique(x(1,1,:));
        n2 = unique(y(1,1,:));
        
        
        if length(n1)==1 && length(n2)==1
            moving_grid = 0;
            
            x = squeeze(x(:,:,1));
            y = squeeze(y(:,:,1));
            
            [nx, ny] = size(x);
            
        else
            error('Have not set for moving nest yet')
            %             moving_grid = 1;
            %             [nx, ny, nt] = size(x);
            %
            %             if nc_Var_exist(fwrf, 'PHB') && nc_Var_exist(fwrf, 'PH')
            %                 phb = squeeze(ncread(fwrf, 'PHB'));
            %                 ph = squeeze(ncread(fwrf, 'PH'));
            %             end
            
        end

        
%         if nc_Var_exist(fwrf, 'PB') && nc_Var_exist(fwrf, 'P')
        if P
%             pb0 = ncread(fwrf, 'PB');
%             p0 = ncread(fwrf, 'P');
%             wgrid.p = (pb0 + p0);
%             wgrid.p = wgrid.p / 100;    % unit : hPa
            wgrid.p = w_load_data(fwrf, 'Pressure');
            nz = size(wgrid.p, 3);
            nt = size(wgrid.p, 4);
        end
        
%         if nc_Var_exist(fwrf, 'PHB') && nc_Var_exist(fwrf, 'PH')
        if Z    
%             phb0 = ncread(fwrf, 'PHB');
%             ph0 = ncread(fwrf, 'PH');
%             z = (phb0 + ph0) / G;
            ph = w_load_data(fwrf, 'Geopotential');
            wgrid.z = ph / G;
%             wgrid.z = (z(:,:,1:end-1,:)+z(:,:,2:end,:)) / 2;
%             wgrid.z = wgrid.z;    % unit : m
            nz = size(wgrid.z, 3);
            nt = size(wgrid.z, 4);
        end        
        
        if nc_Var_exist(fwrf, 'HGT')
%             wgrid.hgt = ncread(fwrf, 'HGT');  % unit : m
            wgrid.hgt = w_load_data(fwrf, 'HGT');  % unit : m 
        else
            disp('No Terrain information')
        end      
        
        n = 1;
        
        
    case {'single', 'double'}
        x = double(varargin{1});
        y = double(varargin{2});

        if numel(x)==length(x) && numel(y)==length(y)
            [y, x] = meshgrid(y, x);
        end
        [nx, ny] = size(x);
        
        n = 2;
end

if isempty(Global)
    wgrid.type = check_grid_type(x, y);
else
    wgrid.type = 'Global';
end

if strcmp(wgrid.type, 'Global')
    x = calc_lon_same([MaxLon-360 MaxLon], x);
    % x = calc_lon_same(MaxLon, x);
end
wgrid.MaxLon = MaxLon;

% Read the rest parameters, if any
% theta = 0;
% i = n + 1;
% while i<nargin
%     switch lower(varargin{i})
%         case 'rotate'
%             theta = varargin{i+1};
%     end
%     i = i + 2;
% end
varargin = read_varargin(varargin, {'Rotate'}, {0});
%Rotate = -Rotate;

% Rotate the (x,y), if needed
[x, y] = rotate_theta(x, y, Rotate);
wgrid.rotate = Rotate;

% Calculate nv
k0 = reshape(1:nx*ny, nx, ny);
k1 = k0(1:nx-1, 1:ny-1);
k2 = k0(1:nx-1, 2:ny);
k3 = k0(2:nx, 2:ny);
k4 = k0(2:nx, 1:ny-1);

nv = [k1(:) k2(:) k3(:) k4(:)];




wgrid.x = x;
wgrid.y = y;
wgrid.nx = nx;
wgrid.ny = ny;
wgrid.nz = nz;
wgrid.nt = nt;
wgrid.nv = nv;


%
[wgrid.bdy_x, wgrid.bdy_y] = w_calc_boundary(wgrid);

disp(' ')
disp('------------------------------------------------')
disp('WRF grid:')
disp(['   Dimension :  nx *  ny * nz * nt '])
disp(['               ' num2str(nx) ' x ' num2str(ny) ' x ' num2str(nz) ' x ' num2str(nt)])
disp(['   Longitude : ' num2str(min(x(:))) ' ~ ' num2str(max(x(:)))])
disp(['   Latitude  : ' num2str(min(y(:))) ' ~ ' num2str(max(y(:)))])
disp('------------------------------------------------')
disp(' ')


end

function status = nc_Var_exist(fnc, varname)

status = 0;

ncid = netcdf.open(fnc, 'NOWRITE');

[~,nvars] = netcdf.inq(ncid);
for i = 1 : nvars
    if strcmp(varname, netcdf.inqVar(ncid,i-1))
        status = 1;
        break
    end
end

end


function [x2, y2] = rotate_theta(x1, y1, theta)

theta1 = atan2d(y1, x1);
r = sqrt(x1.^2 + y1.^2);

x2 = r .* cosd(theta1+theta);
y2 = r .* sind(theta1+theta);

end
