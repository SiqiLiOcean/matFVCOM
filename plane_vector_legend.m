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
function [h1, h2] = plane_vector_legend(x, y, u, v, string, varargin)

[h1, ax, ay] = plane_vector(x, y, u, v, varargin{:});
h2 = text(ax(4), ay(4), [' ' string]);

% % varargin = read_varargin(varargin, {'Scale'}, {1});
% % varargin = read_varargin(varargin, {'Color'}, {'k'});
% % varargin = read_varargin(varargin, {'Vh'}, {1});
% % 
% % 
% % DataAspectRatio = get(gca, 'DataAspectRatio');
% % aspect = DataAspectRatio(1) / DataAspectRatio(2); 
% % 
% % xlims = get(gca, 'xlim');
% % Scale0 = diff(xlims) / 500;
% % 
% % theta = atan2d(v, u);
% % spd = sqrt(u.^2 + v.^2);
% % 
% % 
% % Xh = 4;
% % Yh = 2.5;
% % % Vh = 0.1;
% % Yt = 0.3;
% % 
% % n = length(u);
% % 
% % ZERO = zeros(n, 1);
% % x1 = Xh * max(spd/Vh-1, 0);
% % y1 = Yh * min(spd/Vh, 1);
% % x2 = Xh * spd/Vh;
% % yt = ones(n, 1) * Yt;
% % 
% % ax = [ZERO   x1   x1   x2   x1   x1 ZERO ZERO]';
% % ay = [ -yt  -yt  -y1 ZERO   y1   yt   yt  -yt]';
% % 
% % ax = ax * Scale0 * Scale;
% % ay = ay * Scale0 * Scale;
% % 
% % ay = ay / aspect;
% % 
% % 
% % [ax, ay] = rotate_theta(ax, ay, repmat(theta', 8, 1));
% % ax = ax + repmat(x', 8, 1);
% % ay = ay + repmat(y', 8, 1);
% % 
% % 
% % 
% % h1 = patch(ax, ay, Color, 'EdgeColor', Color);
% % h2 = text(ax(4), ay(4), [' ' string]);
% % 
% % if ~isempty(varargin)
% %     set(h1, varargin{:});
% % end
% % 
% % disp(['Vh = ' num2str(Vh)])
