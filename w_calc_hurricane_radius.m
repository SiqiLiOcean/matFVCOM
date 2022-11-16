%==========================================================================
%   
% input  : 
% 
% output :
%
% Siqi Li, SMAST
% yyyy-mm-dd
%
% Updates:
%
%==========================================================================
function [R, R_degree] = w_calc_hurricane_radius(w, spd0, clon, clat)

Dmax =6;
dD = 0.2;

dtheta = 45;

nt = size(spd0, 3);

r = 0 : dD : Dmax;
theta = 0 : dtheta : 359.99;
for it = 1 : nt
    
    % First generate points around the center
    [x, y] = points_from_center(clon(it), clat(it), theta, r);
    
    % Then interpolate the wind spd from grid to these points
    spd_slice = spd0(:,:,it);
    F = scatteredInterpolant(w.x(:), w.y(:), spd_slice(:));
    spd = F(x, y);
    
    spd_mean = movmean(spd, 9, 2);
    
    % Calculate the radius
    [~, iR] = max(spd_mean');
    R_degree(it,:) = r(iR);
    ii = sub2ind(size(x), 1:8, iR);
    R(it,:) =  distance_to_center(clon(it), clat(it), x(ii), y(ii));
    R_mean(it) = mean(R(it,:));
    R_std(it) = std(R(it,:));
    R_degree_mean(it) = mean(R_degree(it,:));
    R_degree_std(it) = std(R_degree(it,:));
    
    
    save test.mat ii x y
%     save test.mat spd spd_mean
    close all
    figure
    set(gcf, 'position', [223 10 760 760])
    j = [6 3 2 1 4 7 8 9];
    pos_x = [.7 .7 .4 .1 .1 .1 .4 .7];
    pos_y = [.4 .7 .7 .7 .4 .1 .1 .1];
    for i = 1 : 8
        
        subplot('position', [pos_x(i) pos_y(i) .3 .3])
        hold on
        box on
        grid on
        plot(r, spd(i,:), 'r.')
        plot(r, spd_mean(i,:), 'r-')
        plot([r(iR(i)) r(iR(i))], [6 36], 'k--')
        ylim([6 36])
        xlim([0 6])
        set(gca, 'xtick', 1:5)
        text(2,10,[num2str(R_degree(it,i)) '^o'])
        text(2,30,[num2str(R(it,i), '%4.0f') 'km'])
        
        if ~any(ismember([1 4 7], j(i)))
            set(gca, 'yticklabel', {})
        end
        if ~any(ismember([7 8 9], j(i)))
            set(gca, 'xticklabel', {})
        end
        
    end
    subplot('position', [.4 .4 .3 .3])
    hold on
    box on
    xl = linspace(min(x(:)), max(x(:)), 100);
    yl = linspace(min(y(:)), max(y(:)), 100);
    [yy, xx] = meshgrid(yl, xl);
    spd_plot = F(xx, yy);
    contourf(xx, yy, spd_plot, 0:5:30);
%     colorbar('south')
    xlim([min(x(:)), max(x(:))])
    ylim([min(y(:)), max(y(:))])
    plot(x', y', '-', 'color', [.8 .8 .8])
    for ir = [2 4]
        itheta = 0:360;
        circ_x = clon(it) + ir*cosd(itheta);
        circ_y = clat(it) + ir*sind(itheta);
        plot(circ_x, circ_y, '-', 'color', [.8 .8 .8])
    end
    for ir = R_degree_mean(it)
        itheta = 0:360;
        circ_x = clon(it) + ir*cosd(itheta);
        circ_y = clat(it) + ir*sind(itheta);
        plot(circ_x, circ_y, 'r-', 'LineWidth', 2)
    end
    for ir = [R_degree_mean(it)-R_degree_std(it) R_degree_mean(it)+R_degree_std(it)]
        itheta = 0:360;
        circ_x = clon(it) + ir*cosd(itheta);
        circ_y = clat(it) + ir*sind(itheta);
        plot(circ_x, circ_y, 'r--', 'LineWidth', 2)
    end
    
    text(xx(10,10), yy(10,10), [num2str(R_mean(it), '%4.0f') 'km'])
    
    for i = 1 : 8
        plot(x(i,iR(i)), y(i,iR(i)), 'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'w')
    end
        
    axis equal
    set(gca, 'xticklabel', {})
    set(gca, 'yticklabel', {})
    

%     pause
    ffig = ['./fig/' num2str(it) '.png'];
    exportgraphics(gcf, ffig,'Resolution',300);
    
end




end

function [x, y] = points_from_center(x0, y0, theta, r)

theta = theta(:);
r = r(:);
n1 = length(theta);
n2 = length(r);

x = nan(n1, n2);
y = nan(n1, n2);

mat_theta = repmat(theta, 1, n2);
mat_r     = repmat(r',   n1,  1);
x = x0 + mat_r .* cosd(mat_theta);
y = y0 + mat_r .* sind(mat_theta);

end


function  r = distance_to_center(x0, y0, x, y)
    
R = 6370;  % Earth radius (km)

dims = size(x);
x = x(:);
y = y(:);

n = length(x);
r = distance(repmat(y0, n, 1), repmat(x0, n, 1), y, x, R);

r = reshape(r, dims);

end



