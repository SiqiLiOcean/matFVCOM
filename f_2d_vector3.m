%==========================================================================
% Draw 2D FVCOM-grid vectors 
%
% input  : 
%    fgrid
%    u
%    v
%      (Optional)
%    'Scale'
%    'List'
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
function  f_2d_vector3(fgrid, u, v, varargin)

if isempty(get(gcf,'Children'))
    error('Draw the axes first')
end

if numel(u) ~= length(u)
    error('The input u and v should have only one dimension.')
end

n = length(u);

varargin = read_varargin(varargin, {'Scale', 'List'}, {1, 1:n});

rotate = fgrid.rotate;

if n==fgrid.node
    x = fgrid.x(List);
    y = fgrid.y(List);
elseif n==fgrid.nele
    x = fgrid.xc(List);
    y = fgrid.yc(List);
else
    error('The length of u is wrong');
end


% Get the aspect of the current figure axes
DataAspectRatio = get(gca, 'DataAspectRatio');
aspect = DataAspectRatio(1) / DataAspectRatio(2); 




% Rotate the u and v
[u, v] = rotate_theta(u(List), v(List), rotate);

u = u * Scale * aspect;
v = v * Scale;

% h = quiver(x, y, u, v, 'k', 'AutoScale', 'off');
% 
% set(h, 'LineWidth', 0.8)
% set(h, 'MaxHeadSize', 0.4)
% if ~isempty(varargin)
%     set(h, varargin{:})
% end

headWidth = 5;
headLength = 8;
LineLength = 0.08;
for i = 1: length(x)
    ah = annotation('arrow',...
        'headStyle','cback1','HeadLength',headLength,'HeadWidth',headWidth);
    set(ah,'parent',gca);
    set(ah,'position',[x(i) y(i) LineLength*u(i) LineLength*v(i)]);
end

end

function [x2, y2] = rotate_theta(x1, y1, theta)

theta1 = atan2d(y1, x1);
r = sqrt(x1.^2 + y1.^2);

x2 = r .* cosd(theta1+theta);
y2 = r .* sind(theta1+theta);

end
