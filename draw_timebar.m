%==========================================================================
% Draw time-bar
%
% input  :
%   name --- group name in cell/string
%   time --- time in cell
%   tlims--- [t1 t2]
% output :
%   
% Siqi Li, SMAST
% 2022-10-24
%
% Updates:
%
%==========================================================================
function draw_timebar(name, time, tlims, varargin)



ny = length(name);
hold on
for i = 1 : ny
%    plot(time{i}, -i, 's', 'color', [0 0.4470 0.7410], varargin{:})
    x = time{i};
    y = x * 0 - i;
    scatter(x, y, 'filled', 'MarkerFaceColor', [0 0.4470 0.7410], varargin{:}) 
end

xlim(tlims)
ylim([-ny-0.5 -0.5])
set(gca, 'ytick', -ny:-1)
set(gca, 'yticklabel', name(end:-1:1))
