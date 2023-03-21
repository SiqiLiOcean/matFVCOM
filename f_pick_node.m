
%==========================================================================
% Pick points from the current figure and get their (x, y) and the nearest
% node numbers
% input  : \
% 
% output :
%   x 
%   y
%   id
%
% Siqi Li, SMAST
% 2021-08-11
%
% Updates:
%
%==========================================================================
function [x, y, id] = f_pick_node(f)

disp('Left click --- select pionts')
disp('Right click --- end selecting')


x = [];
y = [];
id = [];

hold on

enableDefaultInteractivity(gca);
datacursormode off

while 1
    
    [a, b, button] = ginput(1);
    
    c = ksearch([f.x,f.y], [a,b]);
    
    if button == 1
        x = [x; a];
        y = [y; b];
        id = [id; c];
        disp(['---- Node ' num2str(length(x)) ': ' num2str(c)])
        disp([a, b])
 
        plot(x, y, 'ro', ...
                   'MarkerFaceColor', 'w', ...
                   'MarkerSize', 6)
        
    elseif button == 3
        break
        
    end
    
end