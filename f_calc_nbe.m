%==========================================================================
% Calculate nbe (cell id around each cell)
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
function nbe = f_calc_nbe(fgrid)


nv = fgrid.nv;
nele = fgrid.nele;




% All lines 
lines = [nv(:,[1 2]); nv(:,[1 3]); nv(:,[2 3])];
% Sort every row
lines = sort(lines, 2);
% Add the cell id
lines(:,3) = repmat((1:nele)',3,1);
% Sort in column
lines = sortrows(lines);

% All lines without repeat
[~, i_all] = unique(lines(:,1:2), 'rows');
% inner lines (2nd time)
i_inner = find(~ismember(1:nele*3,i_all))';

a = reshape(lines([i_inner-1 i_inner]',3),2,[])';
a = sortrows([a; a(:,[2 1])]);

cell_center = a(:,1);
cell_around = a(:,2);

%
counts = histcounts(cell_center, 1:nele+1);
counts_accum = [0 cumsum(counts(1:end-1))];

%
index = double((cell_center-1)*3) - counts_accum(cell_center)' + (1:length(cell_center))';

nbe = zeros(3, nele) + nele + 1;
nbe(index) = cell_around;
nbe = nbe';


% 
% tmp =reshape(nv(nbve',:)', 3*8, node)';