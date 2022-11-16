%==========================================================================
% Add the North Arrow in the current figure
%
% input  : x --- arrow center x
%          y --- arrow center y
%          (optional)
%          'theta' --- rotated angle (positive for anti-clockwise)
%          'scale' --- bigger arrow (>1) or smaller one (<1)
%          'color' --- arrow color
% 
% output : p1 --- the handle for left arrow part
%          p2 --- the handle for right arrow part
%          p3 --- the handle for 'N'
%
% Usage  : N_arrow(x0, y0);

%
% Siqi Li, SMAST
% 2021-06-21
%
% Updates:
%
%==========================================================================
function [p1, p2, p3] = N_arrow(x, y, varargin)

if isempty(get(gcf,'Children'))
    error('Draw the axes first')
end

% theta = 0;
% scale = 1;
% color = [30, 42, 74]/255;
% i = 1;
% while i<length(varargin)
%     switch lower(varargin{i})
%         case 'theta'
%             theta = varargin{i+1};
%             varargin(i:i+1) = [];
%             i = i -2;
%         case 'scale'
%             scale = varargin{i+1};
%             varargin(i:i+1) = [];
%             i = i -2;
%         case 'color'
%             color = varargin{i+1};
%             varargin(i:i+1) = [];
%             i = i -2;
%     end
%     i = i + 2;
% end
varargin = read_varargin(varargin, {'Rotate', 'Scale', 'Color'}, {0, 1, [30, 42, 74]/255});

% Rotate = -Rotate;


% Original arrow matrix
arrow1_x = [   0  1.5    0    0];
arrow1_y = [-1.5 -2.5  2.5 -1.5];
arrow2_x = [   0 -1.5    0    0];
arrow2_y = [-1.5 -2.5  2.5 -1.5];
N_x      = [-0.7 -0.7  0.7  0.7  0.7 -0.7 -0.7];
N_y      = [   5    3    5    3    5    3    5];


    
% Get the basic information of the figure
xlims = get(gca, 'xlim');
ylims = get(gca, 'ylim');
axis_len_x = diff(xlims);
axis_len_y = diff(ylims);
gcf_position = get(gcf, 'position');
gca_position = get(gca, 'position');
figure_len_x = gcf_position(3) * gca_position(3);
figure_len_y = gcf_position(4) * gca_position(4);
DataAspectRatio = get(gca, 'DataAspectRatio');
% DataAspectRatioMode = get(gca, 'DataAspectRatioMode');

% --- Calculate the ratios
ratio_figure = figure_len_x / figure_len_y;
% if sum(DataAspectRatio == 1) == 3
%     ratio_axis = ratio_figure;
% else
%     ratio_axis = axis_len_x / axis_len_y;
% end
aspect = DataAspectRatio(1) / DataAspectRatio(2); 

% --- Calculate the scale

% % Use the longer length to decide the scale0
% if ratio_figure > 2.5
%     scale0 = axis_len_x  / 20;
% else
%     scale0 = axis_len_x / ratio_figure / 20;
% end

% % Use the shorter length to decide the scale0
% if ratio_figure > 2.5
%     scale0 = axis_len_x / ratio_figure / 20;
% else
%     scale0 = axis_len_x  / 20;
% end

% Use both length to get a mean value
scale0 = axis_len_x / ((ratio_figure+1)/2) / 20;

scale0 = scale0 / 3 * Scale;


% Rotate the arrow
[arrow1_x, arrow1_y] = rotate_theta(arrow1_x, arrow1_y, Rotate);
[arrow2_x, arrow2_y] = rotate_theta(arrow2_x, arrow2_y, Rotate);
[N_x, N_y] = rotate_theta(N_x, N_y, Rotate);


% Apply the scale and ratios
arrow1_x = arrow1_x * scale0 * aspect / ratio_figure;
arrow1_y = arrow1_y * scale0;
arrow2_x = arrow2_x * scale0 * aspect / ratio_figure;
arrow2_y = arrow2_y * scale0;
N_x = N_x * scale0  * aspect / ratio_figure;
N_y = N_y * scale0;

% Move the arrow centered at (x,y)
arrow1_x = arrow1_x + x;
arrow1_y = arrow1_y + y;
arrow2_x = arrow2_x + x;
arrow2_y = arrow2_y + y;
N_x = N_x + x;
N_y = N_y + y;



hold on;
p1 = patch(arrow1_x, arrow1_y, Color, 'linewidth', 1.3, 'EdgeColor', Color);
p2 = patch(arrow2_x, arrow2_y, Color, 'linewidth', 1.3, 'EdgeColor', Color, 'FaceColor', 'w');
% p3 = patch(     N_x,      N_y, Color, 'linewidth', 2.3, 'EdgeColor', Color);
p3=[];

% plot(arrow1_x, arrow1_y, 'r-')
% plot(arrow2_x, arrow2_y, 'b-')
% plot(N_x, N_y, 'k-')

end

function [x2, y2] = rotate_theta(x1, y1, theta)

theta1 = atan2d(y1, x1);
r = sqrt(x1.^2 + y1.^2);

x2 = r .* cosd(theta1+theta);
y2 = r .* sind(theta1+theta);

end
