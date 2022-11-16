%==========================================================================
% Pick a line from the current figure and get their (x, y)
% input  : \
% 
% output :
%   x 
%   y
%
% Siqi Li, SMAST
% 2021-08-11
%
% Updates:
%
%==========================================================================
function [x, y] = pick_line

disp('Left click --- select pionts')
disp('Right click --- end selecting')


x = [];
y = [];

hold on

enableDefaultInteractivity(gca);
while 1
    
    [a, b, button] = ginput(1);
    
    if button == 1
        x = [x; a];
        y = [y; b];
 
        plot(x, y, 'r-o', ...
                   'LineWidth', 1.3, ...
                   'MarkerFaceColor', 'r', ...
                   'MarkerSize', 6)
        
    elseif button == 3
        break
        
    end
    
end