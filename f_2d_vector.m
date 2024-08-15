%==========================================================================
%   
%
%
%                  (x1,y1)
%                    |\ 
%                    | \
% (0,yt)  -----------|  \
%         |          |   \  (x2,0)
%         |          |   /
% (0,-yt) -----------|  /
%                    | /
%                    |/
%                  (x1,-y1)
%     
% set max head length  Xh = 3
%     max head height  Yh = 1.5
%     critial velocity Vh = 0.1 (When there is only max head with no tail)
%     tail height      Yt = 0.1
%
% x1 = Xh * max(V/Vh-1, 0);
% y1 = Yh * min(V/Vh, 1);
% x2 = Xh * V/Vh;
%
% input  : 
% 
% output :
%
% Siqi Li, SMAST
% 2021-09-02
%
% Updates:
%
%==========================================================================
function [h, para] = f_2d_vector(fgrid, u, v, varargin)

varargin = read_varargin(varargin, {'List'},  {1:fgrid.nele});
varargin = read_varargin(varargin, {'Scale'}, {1});
varargin = read_varargin(varargin, {'Color'}, {'k'});
varargin = read_varargin(varargin, {'Vh'}, {[]});
varargin = read_varargin(varargin, {'Vmax'}, {[]});


Xh = 4;
Yh = 3; %2.5; %1.5;
Yt = 0.3;


x = fgrid.xc(List);
y = fgrid.yc(List);
u = u(List);
v = v(List);

% Rotate the current if needed
if fgrid.rotate~=0
    [u, v] = rotate_vector(u, v, fgrid.rotate);
end

DataAspectRatio = get(gca, 'DataAspectRatio');
aspect = DataAspectRatio(1) / DataAspectRatio(2); 

xlims = get(gca, 'xlim');
Scale0 = diff(xlims) / 500;

theta = atan2d(v, u);
spd = sqrt(u.^2 + v.^2);

if ~isempty(Vmax)
    disp(111)
    spd(spd>Vmax) = 0;
end

if isempty(Vh)
    spd_sorted = sort(spd);
    n_percent = max(round(length(spd_sorted)*0.05), 1);
    v_percent = spd_sorted(n_percent);
    p = floor(log10(v_percent));
    v_percent = round(v_percent/(10^p)) * 10^p;
    varargin = read_varargin(varargin, {'Vh'}, {v_percent});
    % disp(['Arrow head speed: ' num2str(v_5percent)])
end

n = length(u);

ZERO = zeros(n, 1);
x1 = Xh * max(spd/Vh-1, 0);
y1 = Yh * min(spd/Vh, 1);
x2 = Xh * spd/Vh;
yt = ones(n, 1) * Yt;

ax = [ZERO   x1   x1   x2   x1   x1 ZERO ZERO]';
ay = [ -yt  -yt  -y1 ZERO   y1   yt   yt  -yt]';

ax = ax * Scale0 * Scale;
ay = ay * Scale0 * Scale;

ay = ay / aspect;


[ax, ay] = rotate_theta(ax, ay, repmat(theta', 8, 1));
ax = ax + repmat(x', 8, 1);
ay = ay + repmat(y', 8, 1);



h = patch(ax, ay, Color, 'EdgeColor', Color);
if ~isempty(varargin)
    set(h, varargin{:});
end

disp(['Vh = ' num2str(Vh)])
para.Scale = Scale;
para.Vh = Vh;

end

function [u2, v2] = rotate_vector(u1, v1, angel)

[spd, dirc] = calc_uv2current(u1, v1);
dirc = dirc + angel;
[u2, v2] = calc_current2uv(spd, dirc);

end
