%==========================================================================
% Draw a vector legend 
%
% input  : 
%    x
%    y
%    u
%    txt
%      (Optional)
%    'Scale'
% 
% output :
%    h
%
% Siqi Li, SMAST
% 2021-06-24
%
% Updates:
%
%==========================================================================
function [h1, h2] = vector_legend(x, y, u, txt, varargin)


varargin = read_varargin(varargin, {'Scale'}, {1});
varargin = read_varargin(varargin, {'Color'}, {'k'});
varargin = read_varargin(varargin, {'FontSize'}, {16});

v = 0;

Xh = 4;
Yh = 2.5; %1.5;
Yt = 0.3;

% % 
% % x = fgrid.xc(List);
% % y = fgrid.yc(List);
% % u = u(List);
% % v = v(List);
% % 
% % % Rotate the current if needed
% % if fgrid.rotate~=0
% %     [u, v] = rotate_vector(u, v, fgrid.rotate);
% % end

DataAspectRatio = get(gca, 'DataAspectRatio');
aspect = DataAspectRatio(1) / DataAspectRatio(2); 

xlims = get(gca, 'xlim');
Scale0 = diff(xlims) / 500;

% % theta = atan2d(v, u);
% % spd = sqrt(u.^2 + v.^2);
spd = u;

% spd_sorted = sort(spd);
% n_5percent = max((round(length(spd_sorted)*0.05, 0)));
% v_5percent = spd_sorted(n_5percent);
% v_5percent = round(v_5percent*10) / 10;
% varargin = read_varargin(varargin, {'Vh'}, {v_5percent});
% disp(['Arrow head speed: ' num2str(v_5percent)])
varargin = read_varargin(varargin, {'Vh'}, {0.3});

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


% [ax, ay] = rotate_theta(ax, ay, repmat(theta', 8, 1));
ax = ax + repmat(x', 8, 1);
ay = ay + repmat(y', 8, 1);



h1 = patch(ax, ay, Color, 'EdgeColor', Color);

h2 = text(ax(4), ay(4), [' ' txt]);
set(h2, 'FontSize', FontSize)

if ~isempty(varargin)
    set(h, varargin{:});
end


% if isempty(get(gcf,'Children'))
%     error('Draw the axes first')
% end
% 
% 
% varargin = read_varargin(varargin, {'Scale'}, {1});
% 
% 
% % Most time the arrow is too small. 
% xlims = get(gca, 'xlim');
% Scale0 = diff(xlims) / 25;
% 
% u = u * Scale0 * Scale;
% v = 0;
% 
% 
% 
% h1 = quiver(x, y, u, v, 'k', 'AutoScale', 'off');
% 
% 
% set(h1, 'LineWidth', 0.85)
% set(h1, 'MaxHeadSize', 0.5)
% 
% h2 = text(x+1.1*u, y+1.1*v, txt);
% set(h2, 'FontSize', 16)
% 
% if ~isempty(varargin)
%     set(h1, varargin{:})
% end



end
