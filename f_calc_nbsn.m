%==========================================================================
% Calculate nbsn (node id around each node)
% input  : 
% 
% output :
%
% Siqi Li, SMAST
% 2021-06-30
%
% Updates:
%
%==========================================================================
function nbsn = f_calc_nbsn(fgrid)


nv = fgrid.nv;
nbve = fgrid.nbve;
node = fgrid.node;
nele = fgrid.nele;

max_ntve = size(nbve, 2);

nv(nele+1, :) = node + 1;
% 
a =reshape(nv(nbve',:)', 3*max_ntve, node);

node_list = repmat(1:node, max_ntve*3, 1); 

b = [a(:) node_list(:)];

k = b(:,1) == b(:,2) | b(:,1) == node+1;
b(k,:) = [];

b = unique(b,'rows');

node_center = b(:,1);
node_around = b(:,2);

% 
counts = histcounts(node_center, 1:node+1);
counts_accum = [0 cumsum(counts(1:end-1))];


%
index = double((node_center-1)*max_ntve) -  counts_accum(node_center)' + (1:length(node_center))';

nbsn = zeros(max_ntve, node) + node+1;
nbsn(index) = node_around;
nbsn = nbsn';

