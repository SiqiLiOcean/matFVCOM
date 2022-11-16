%==========================================================================
%
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
function ns2 = f_grid_cp_ns(fgrid1, ns1, fgrid2, varargin)

varargin = read_varargin(varargin, {'Eps'}, {1e-8});

x1 = fgrid1.x;
y1 = fgrid1.y;
x2 = fgrid2.x;
y2 = fgrid2.y;


for i = 1 : length(ns1)
    [id, d] = knnsearch([x2, y2], [x1(ns1{i}) y1(ns1{i})]);
    
    if any(d>Eps)
        disp(['The following nodes on NS ' num2str(i) ' does not match those in grid2:'])
%         disp(find(d>Eps))
        error('')
    end
    
    ns2{i,1} = id;
end
    
    
    
    
    
    
    
    
    
    
    