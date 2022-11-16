%==========================================================================
% Calculate nbve (cell id around each node)
% input  : 
% 
% output :
%
% Siqi Li, SMAST
% 2021-05-29
%
% Updates:
%
%==========================================================================
function nbve = f_calc_nbve(fgrid)

% clc
% clear
% 
% fin='./data/gom3_example.nc';
% 
% % Read input grid
% fgrid = f_load_grid(fin, 'xy');
% 
% nv = fgrid.nv;
% 
% node = fgrid.node;
% nele = fgrid.nele;

nv = fgrid.nv;

% Dimensions
node = fgrid.node;
nele = fgrid.nele;


% Node id columns
nv_l = [reshape(nv', nele*3, 1)  reshape(repmat(1:nele,3,1), [],1)];
nv_l = sortrows(nv_l);

node_center = nv_l(:,1);
cell_around = nv_l(:,2);

% 
counts = histcounts(node_center, 1:node+1);
max_ntve = max(counts);
counts_accum = [0 cumsum(counts(1:end-1))];


%
index = double((node_center-1)*max_ntve) -  counts_accum(node_center)' + (1:nele*3)';

nbve = zeros(max_ntve, node) + nele+1;
nbve(index) = cell_around;
nbve = nbve';






% Set an initial value for max_ntve (the maximum cell # around nodes)
% max_ntve = 10;
% 
% nbve = zeros(node, max_ntve);


% Method 3
% nv1 = nv(:,1);
% nv2 = nv(:,2);
% nv3 = nv(:,3);
% for i = 1 : node
%     
%     if mod(i,5000)==0
%         disp([num2str(i) ' / ' num2str(node)])
%     end
%     
%     i1 = find(nv1==i);
%     i2 = find(nv2==i);
%     i3 = find(nv3==i);
%     ia = [i1; i2; i3];
%     nbve(i,1:length(ia)) = ia;
%     
% end
% nbve = ceil(nbve/3);

% % Method 2
% nv_l = reshape(nv', nele*3, 1);
% for i = 1 : node
%     
%     if mod(i,5000)==0
%         disp([num2str(i) ' / ' num2str(node)])
%     end
%     
%     ia = find(nv_l==i);
%     nbve(i,1:length(ia)) = ia;
%     
% end
% nbve = ceil(nbve/3);

% Method 1
% for i = 1 : node
%     
%     if mod(i,5000)==0
%         disp([num2str(i) ' / ' num2str(node)])
%     end
%     [ia, ~] = find(nv==i);
%     nbve(i,1:length(ia)) = ia;
%     
% end


% Reset the max_ntve
% max_ntve = sum(max(nbve,[],1)>0);
% nbve(:, max_ntve+1:end) = [];
% 
% nbve(nbve==0) = nele+1;
% 
% fgrid.nbve = nbve;
% assignin('caller', inputname(1), fgrid)
