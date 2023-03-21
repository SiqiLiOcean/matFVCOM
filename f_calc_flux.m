%==========================================================================
% Calculate flux using FVCOM data
% Sign: Standing on one point and facing the next one, the transport is 
%       positive when water comes from left to right.
% Unit: C*m^3/s (C is the unit of the input con)
%
% input  :
%   fgrid
%   u    : (n, siglay, nt) or (n, nt) with 'Average'
%   v    : (n, siglay, nt) or (n, nt) with 'Average'
%   con  : (n, siglay, nt) or (n, nt) with 'Average'
%   x0
%   y0
%   'npixel'
%   'Zeta'
%   'Order'
%   'Geo'
%   'Average'
% 
%   Set con = 1 if you want to calcuate the transport
%
% output :
%
% Siqi Li, SMAST
% 2021-10-20
%
% Updates:
% 2023-03-21  Siqi Li  Allowed to read the depth-averaged variables (ua, 
%                      va, and cona)
%==========================================================================
function [flux, sec] = f_calc_flux(fgrid, u, v, con, x0, y0, varargin)


varargin = read_varargin(varargin, {'npixel'}, {200});
varargin = read_varargin(varargin, {'Zeta'}, {zeros(fgrid.node,size(u,3))});
varargin = read_varargin(varargin, {'Order'}, {1});
varargin = read_varargin2(varargin, {'Geo'});
varargin = read_varargin2(varargin, {'Average'});



x0 = x0(:);
y0 = y0(:);

% Add the intersec points into (x0, y0)
[xi, yi, ii] = polyxpoly([fgrid.bdy_x{:}], [fgrid.bdy_y{:}], x0, y0);
for i = size(ii,1) : -1 :1
    a = ii(i,2);
    x0 = [x0(1:a); xi(i); x0(a+1:end)];
    y0 = [y0(1:a); yi(i); y0(a+1:end)];
end

% Calculate vertically averaged velocity
if ~isempty(Average)
    ua = u;
    va = v;
    cona = con;
else
    [ua, va] = f_calc_ua(fgrid, u, v, 'Order', Order);
    cona = f_calc_depth_avg(fgrid, con, 'Order', Order);
end


% Interpolate the water depth onto the section
[h_sec, x_sec, y_sec, d_sec] = f_interp_transect(fgrid, fgrid.h, x0, y0, 'npixel', npixel);

for it = 1 : size(u, 3)

% Interpolate the velocity and zeta onto the section
zeta_sec(:,it) = f_interp_transect(fgrid, Zeta(:,it), x0, y0, 'npixel', npixel);
u_sec(:,it) = f_interp_transect(fgrid, ua(:,it), x0, y0, 'npixel', npixel);
v_sec(:,it) = f_interp_transect(fgrid, va(:,it), x0, y0, 'npixel', npixel);
con_sec(:,it) = f_interp_transect(fgrid, cona(:,it), x0, y0, 'npixel', npixel);




% Caluclate the transport
flux_sec(:,it) = nan(length(h_sec)-1, 1);
for i = 1 : length(h_sec)-1

    if ~any(isnan(h_sec(i:i+1)))
        if Geo
            l = calc_distance(x_sec(i), y_sec(i), x_sec(i+1), y_sec(i+1), 'Geo');
        else
            l = sqrt((x_sec(i+1)-x_sec(i))^2 + (y_sec(i+1)-y_sec(i))^2);
        end
        h = (h_sec(i)+zeta_sec(i,it) + h_sec(i+1)+zeta_sec(i+1,it)) * 0.5;
        u = (u_sec(i,it) + u_sec(i+1,it)) * 0.5;
        v = (v_sec(i,it) + v_sec(i+1,it)) * 0.5;
        con = (con_sec(i,it) + con_sec(i+1,it)) * 0.5;
        spd = sqrt(u^2 + v^2);
        angle_sec = atan2d(y_sec(i+1)-y_sec(i), x_sec(i+1)-x_sec(i));
        angle_current = atan2d(v, u);
        angle = angle_sec - angle_current;
        current = spd * sind(angle);
%         tpt_sec(i,it) = current * l * h;
        flux_sec(i,it) = con * current * l * h;
    end
end

end

flux = nansum(flux_sec, 1)';    % flux
sec.x = x_sec;
sec.y = y_sec;
sec.d = d_sec;
sec.h = h_sec;
sec.zeta = zeta_sec;
sec.u = u_sec;
sec.v = v_sec;
sec.xc = (x_sec(1:end-1) + x_sec(2:end)) * 0.5;
sec.yc = (y_sec(1:end-1) + y_sec(2:end)) * 0.5;
sec.dc = (d_sec(1:end-1) + d_sec(2:end)) * 0.5;
sec.hc = (h_sec(1:end-1) + h_sec(2:end)) * 0.5;
% sec.tpt = tpt_sec;
sec.flux = flux_sec;
