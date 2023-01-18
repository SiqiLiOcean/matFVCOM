%==========================================================================
% Mask the region out of the FVCOM grid boundary
%
% input  : x   (x coordinate)
%          y   (y coordinate)
%          nv  (triangle matrix)
%          (the three variables above will be got from fgrid)
% output : h (figure handle)
%
% Siqi Li, SMAST
% 2021-03-10
%==========================================================================
function h = f_2d_mask_boundary(fgrid, varargin)




% varargin = read_varargin2(varargin, {'Global'});

% fgrid = f2;
% Global = 1;


x = fgrid.x;
y = fgrid.y;

% if isfield(fgrid, 'bdy_x') && isfield(fgrid, 'bdy_y')
%     bdy_x = [fgrid.bdy_x{:}];
%     bdy_y = [fgrid.bdy_y{:}];
% else
%     disp('Calculate boundary first...')
%     [bdy_x, bdy_y] = f_calc_boundary(fgrid);
%     fgrid.bdy_x = bdy_x;
%     fgrid.bdy_y = bdy_y;
%     assignin('base', inputname(1), fgrid)
% end


tmpx = fgrid.bdy_x;
tmpy = fgrid.bdy_y;

nbdy = length(tmpx);

if strcmp(fgrid.type, 'Global')
    for i = nbdy : -1 : 1
        ax = tmpx{i};
        ay = tmpy{i};
        
        if min(ay)<-70
            ax = ax(1:end-1);
            ay = ay(1:end-1);
            
            if max(abs(diff(ax))) > 300
                dif = diff(ax);
                [~, k1]=max(abs(dif));
                k2 = k1 + 1;
                k = [k1:-1:1 length(ax):-1:k2];
                ax = ax(k);
                ay = ay(k);
            end
            
            ax = [ax ax(end) ax(1) ax(1) NaN];
            ay = [ay     -90   -90 ay(1) NaN];
            
            tmpx{i} = ax;
            tmpy{i} = ay;
            continue
            
        end
        
        if max(abs(diff(ax))) > 300
            for j = 2 : length(ax)
                dif = ax(j) - ax(j-1);
                if dif < -300
                    flag = 360;
                elseif dif > 300
                    flag = 360;
                else
                    flag = 0;
                end
                ax(j) = ax(j) + flag;
            end
            
            tmpx{i} = ax;
            tmpx{length(tmpx)+1} = ax -360;
            tmpy{length(tmpy)+1} = ay;
            
        end
    end
    
end


% % 
% % close all
% % figure
% % hold on
% % plot(ax, ay, 'r-')
% % plot(ax(1:148), ay(1:148), 'k.')
% % plot(ax(149:end)-360, ay(149:end), 'b.')
% % 
% % 
% % plot([tmpx{286}(1:end-0)], [tmpy{286}(1:end-0)], 'k-')
% % plot([f2.bdy_x{286}], [f2.bdy_y{286}], 'b-')
% % 
% % close all
% % figure
% % plot([f2.bdy_x{286}], [f2.bdy_y{286}], 'k-')



bdy_x = [tmpx{:}];
bdy_y = [tmpy{:}];


% Get the xlim and ylim of the current figure
xlims = get(gca, 'xlim');
ylims = get(gca, 'ylim');







pct = 0.01;
x1 = min(x)-pct*(max(x)-min(x));
y1 = min(y)-pct*(max(y)-min(y));
x2 = max(x)+pct*(max(x)-min(x));
y2 = max(y)+pct*(max(y)-min(y));

% if Global
if strcmp(fgrid.type, 'Global')
    xl = [bdy_x(:)'];
    yl = [bdy_y(:)'];
%     xlims = minmax(x);
%     ylims = minmax(y);
    xlims = [fgrid.MaxLon-360. fgrid.MaxLon];
    ylims = [-90 90];
else
    xl = [x1 x2 x2 x1 nan bdy_x(:)'];
    yl = [y1 y1 y2 y2 nan bdy_y(:)'];
end

pgon = polyshape(xl, yl, 'KeepCollinearPoints', true);

hold on
h = plot(pgon);
set(h, 'LineStyle', 'none');
set(h, 'FaceColor', 'w');
set(h, 'FaceAlpha', 1);
axis([xlims(1) xlims(2) ylims(1) ylims(2)])

if ~isempty(varargin)
    set(h, varargin{:});
end

set(gca, 'Layer', 'Top')
