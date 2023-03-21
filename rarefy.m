function k_out = rarefy(x0, y0, d0, varargin)



varargin = read_varargin(varargin, {'xlims', 'ylims'}, {[min(x0) max(x0)], [min(y0) max(y0)]});

% if isempty(varargin)
%     xlims = [min(x0) max(x0)];
%     ylims = [min(y0) max(y0)];
% else
%     xlims = varargin{1};
%     ylims = varargin{2};
% end

% Pick out the points in selected domain
k1 = find(x0>=xlims(1) & x0<=xlims(2) & y0>=ylims(1) & y0<=ylims(2));
x1 = x0(k1);
y1 = y0(k1);


%-------version 3--------------------------------
%----32s
% Re-number the x and y on resolution
[~, D] = ksearch([x1,y1], [x1,y1], 'K', 2);
[~, k2] = sort(D(:,2), 'descend');
x2 = x1(k2);
y2 = y1(k2);

% Rarefy the points based on resolution
k3 = 1 : 1 : length(k2);
i = sum(D(:,2)>=d0) + 1;
while i< length(k3)
    
    if (mod(i,1000) == 0)
        disp([i,length(k3)])
    end
    
%     dxy = sqrt( (x2(id(i+1:end))-x2(id(i))).^2 + ...
%                 (y2(id(i+1:end))-y2(id(i))).^2 );
    dxy = pdist2([x2(k3(i+1:end)), y2(k3(i+1:end))], ...
                 [x2(k3(i)), y2(k3(i))]);
    k = find(dxy<d0);
    k3(k+i) = [];
    i = i+1;
    
end

k_out = k1(k2(k3));
% 
% figure
% hold on
% draw_2d(f, [], 'EdgeColor', [.8 .8 .8]);
% plot(f.xc(id), f.yc(id), 'r.')

%-------version 2--------------------------------
% %----39s
% n = length(x0);
% id = 1 : 1 : n;
% i = 1;
% 
% while i< length(id)
%     
%     if (mod(i,100) == 1)
%         disp([i,length(id)])
%     end
%     
%     dxy = sqrt( (x0(id(i+1:end))-x0(id(i))).^2 + ...
%                 (y0(id(i+1:end))-y0(id(i))).^2 );
%     k = find(dxy<d);
%     id(k+i) = [];
%     i = i+1;
%     
% end
% 
% 
% 
% figure
% hold on
% draw_2d(f, [], 'EdgeColor', [.8 .8 .8]);
% plot(f.xc(id), f.yc(id), 'r.')
%-------version 1--------------------------------

% x = x0;
% y = y0;
% 
% i = 1;
% while i<length(x)
%     
%     dx = x-x(i);
%     dy = y-y(i);
%     dxy = sqrt(dx.^2+dy.^2);
%     p_close = find(dxy<d);
%     
%     x(p_close) = [];
%     y(p_close) = [];
%     
%     i = i + 1;
%     
% end
%     
% id = find(ismember(x0, x));
