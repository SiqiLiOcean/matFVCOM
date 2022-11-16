%==========================================================================
% Pick points from a picture and get their (x, y)
% input  : 
%   ffig --- the path and name of input figure file
% output :
%   x --- x of selected points
%   y --- y of selected points
%
% Siqi Li, SMAST
% 2021-11-23
%
% Updates:
%
%==========================================================================
function [x, y] = pick_from_image(ffig, varargin)


if ~isempty(varargin)
    x1 = varargin{1}(1);
    x2 = varargin{1}(2);
    x3 = varargin{1}(3);
    y1 = varargin{2}(1);
    y2 = varargin{2}(2);
    y3 = varargin{2}(3);
else
    x1 = [];
    x2 = [];
    x3 = [];
    y1 = [];
    y2 = [];
    y3 = [];
end
    

A = imread(ffig);

figure
imshow(A);
hold on
enableDefaultInteractivity(gca);

disp('=============================================')
disp('  Click three points and type their (x,y)')
[m1, n1] = ginput(1);
plot(m1, n1, '--gs',...
    'MarkerSize',10,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.5,0.5,0.5])
if isempty(x1)
    x1 = input('  --- Point 1 x:  ');
    y1 = input('  --- Point 1 y:  ');
end
text(m1, n1, ['(' num2str(x1) ',' num2str(y1) ')'])

[m2, n2] = ginput(1);
plot(m2, n2, '--gs',...
    'MarkerSize',10,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.5,0.5,0.5])
if isempty(x2)
    x2 = input('  --- Point 2 x:  ');
    y2 = input('  --- Point 2 y:  ');
end
text(m2, n2, ['(' num2str(x2) ',' num2str(y2) ')'])

[m3, n3] = ginput(1);
plot(m3, n3, '--gs',...
    'MarkerSize',10,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.5,0.5,0.5])
if isempty(x3)
    x3 = input('  --- Point 3 x:  ');
    y3 = input('  --- Point 3 y:  ');
end
text(m3, n3, ['(' num2str(x3) ',' num2str(y3) ')'])

Fx = scatteredInterpolant([m1; m2; m3], [n1; n2; n3], [x1; x2; x3]);
Fy = scatteredInterpolant([m1; m2; m3], [n1; n2; n3], [y1; y2; y3]);

disp(' ')
disp(' Click the points you want to select')
disp('Left click --- select pionts')
disp('Right click --- end selecting')


m = [];
n = [];

while 1
    [a, b, button] = ginput(1);
    
    if button == 1
        m = [m; a];
        n = [n; b];
        plot(a, b, 'bo', ...
                   'MarkerFaceColor', 'r', ...
                   'MarkerSize', 6)
    elseif button == 3
        break
    end
end

x = Fx(m, n);
y = Fy(m, n);

if nargout == 0 
    for i = 1 : length(x)
        disp([x(i) y(i)])
    end
end
        
