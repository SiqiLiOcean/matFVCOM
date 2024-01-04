%==========================================================================
% Check the grid to find out the duplicated cells and nodes
%
% Input  : --- fgrid
%
% Output : --- nv_new, the corrected nv (or the original right nv)
%
% Usage  : nv_new = f_check_grid(f);
%
% v1.0
%
% Siqi Li
% 2021-04-22
%
% Updates:
% 2022-04-15  Siqi Li  Added nodestring
%==========================================================================
function fgrid = f_grid_check(fgrid0, varargin)

varargin = read_varargin(varargin, {'Eps'}, {1e-6});

fgrid = fgrid0;
%==========> Part 1 : check if there is duplicated cell.
nele = fgrid.nele;
nv = fgrid.nv;

nv_new = nv;

nv1 = sort(nv, 2);
% [nv2, ia, ic] = unique(nv1, 'rows');
[~, ia] = unique(nv1, 'rows');

repeat_cell = find(~ismember(1:nele, ia));


disp(' ')
disp('------------------------------------------------')

rm_cells = [];
if isempty(repeat_cell)
    
    disp(' There is no duplicated cell.')
    
    
else
    disp([' The following ' num2str(length(repeat_cell)) ' cells are duplicated:'])
    
    for i = 1 : length(repeat_cell)
        
        cells = find(ismember(nv1, nv1(repeat_cell(i),:), 'rows'));
        for j = 1 : length(cells)
            if j == 1
                fprintf('%s%9d%s%9d%9d%9d\n', '---> ', cells(j), ':', nv(cells(j),:));
            else
                rm_cells = [rm_cells; cells(j)];
                fprintf('%s%9d%s%9d%9d%9d\n', '     ', cells(j), ':', nv(cells(j),:));
            end
        end
        disp(' ')
    end
    
    
    
    nv_new(rm_cells,:) = []; 
    
    fgrid.nv = nv_new;
    
    
end

disp('------------------------------------------------')
disp(' ')



%==========> Part 2 : check if there is duplicated node.
% fgrid =f;
x = fgrid.x;
y = fgrid.y;
nv = fgrid.nv;
h = fgrid.h;

disp(' ')
disp('------------------------------------------------')

% Find the nearerst neighbor of each node
[id, R] = ksearch([x,y], [x,y], 'K',2);
% id = id(:,2);
R = R(:,2);

% Get the duplicated nodes match
k = find(R < Eps);
if isempty(k)
    disp(' There is no duplicated node.')
else
    node_match = id(k,:);
    id = 1 : length(x);
    for i = 1 : length(k)
        if node_match(i,1) == k(i)
            node_match(i,:) = node_match(i,[2 1]);
        elseif node_match(i,2) == k(i)
            
        else
            error('There seems to be more than two points at the same place')
        end
        if node_match(i,1)<k(i)
            num1 = node_match(i,1);
            num2 = node_match(i,2);

            fprintf('%9d%s%9d\n', num2, '  ---> ', num1);
            x(num2) = nan;
            y(num2) = nan;
            id(num2) = nan;
            nv(nv==num2) = num1;
        end
    end
    disp([' There are totally ' num2str(sum(isnan(x))) ' duplicated nodes'])
    
% % %     node_match = [k id(k)];
% % %     for i = size(node_match,1) : -1 :1
% % %         if node_match(i,1) >= node_match(i,2)
% % %             node_match(i,:) = [];
% % %         end
% % %     end
% % %     
% % %     % Sometime there are more than two nodes at the same place
% % %     points = intersect(node_match(:,1), node_match(:,2));
% % %     for i = 1 : length(points)
% % %         i1 = node_match(:,1) == points(i);
% % %         i2 = node_match(:,2) == points(i);
% % %         node_match(i1,1) = node_match(i2,1);
% % %     end
% % % 
% % %     id = 1 : length(x);
% % %     disp([' The following ' num2str(size(node_match,1)) ' nodes are duplicated:'])
% % %     for i = 1 : size(node_match, 1)
% % %         
% % %         num1 = node_match(i,1);
% % %         num2 = node_match(i,2);
% % %         
% % %         fprintf('%9d%s%9d\n', num2, '  ---> ', num1);
% % %         x(num2) = nan;
% % %         y(num2) = nan;
% % %         id(num2) = nan;
% % %         nv(nv==num2) = num1;
% % %     end
    
    
    x = x(~isnan(x));
    y = y(~isnan(y));
    h = h(~isnan(x));
    id = id(~isnan(id));
    
    nv = renumber_grid(nv, id);
    
    fgrid = f_load_grid(x, y, nv, h);
end
disp('------------------------------------------------')
disp(' ')

%==========> Part 3 : remove the unused nodes
x = fgrid.x;
y = fgrid.y;
nv = fgrid.nv;
h = fgrid.h;

disp(' ')
disp('------------------------------------------------')

id_from_nv = sort(unique(nv(:)));

if length(x)==length(id_from_nv) && length(x)==max(id_from_nv)
    disp(' There is no unused node.')
else
    
    node_used = ismember(1:length(x), id_from_nv);
    
    disp([' There are ' num2str(length(x)-sum(node_used)) ' unused nodes.'])
    disp([find(~node_used)]')
    disp([' They are removed now.'])
    
    x = x(node_used);
    y = y(node_used);
    h = h(node_used);
    nv = renumber_grid(nv, find(node_used));
end
    
    

fgrid = f_load_grid(x, y, nv, h);

if isfield(fgrid0, 'ns')
    fgrid.ns = f_grid_cp_ns(fgrid0, fgrid0.ns, fgrid);
end

disp('------------------------------------------------')
disp(' ')

