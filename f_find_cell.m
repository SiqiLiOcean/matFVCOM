%==========================================================================
%
%
% input  :
%
% output :
%
% Siqi Li, SMAST
% 2021-09-17
%
% Updates:
%
%==========================================================================
function [n, d] = f_find_cell(fgrid, x0, y0, varargin)

varargin = read_varargin2(varargin, {'Extrap'});

x = fgrid.x;
y = fgrid.y;
nv = fgrid.nv;
nele = fgrid.nele;

% Nearest node
[n0, d] = ksearch([x,y], [x0(:) y0(:)]);
nbve = fgrid.nbve(n0,:);

n = nan(length(x0), 1);

if ~isempty(Extrap)
    n = ksearch([fgrid.xc fgrid.yc], [x0(:) y0(:)]);
end

for i = 1 : length(x0)
    
    for j = 1 : size(nbve,2)
        if nbve(i,j) > nele
            break
        end
    
        in = inpolygon(x0(i), y0(i), x(nv(nbve(i,j),:)), y(nv(nbve(i,j),:)));
        
        if in
            n(i) = nbve(i,j);
            break
        end
    end
    
end

