%==========================================================================
% Smooth the FVCOM field (on node or cell)  
% input  : 
%   ---fgrid
%   ---var1
%   ---'List'
%   ---'CenterWeight'
%
% output :
%   ---var2
%
% Siqi Li, SMAST
% 2021-06-30
%
% Updates:
%
%==========================================================================
function var2 = f_smooth(fgrid, var1, varargin)

varargin = read_varargin(varargin, {'CenterWeight'}, {0.5});
varargin = read_varargin(varargin, {'N'}, {1});


node = fgrid.node;
nele = fgrid.nele;

dims1 = size(var1);

if dims1(1) == node
    around = fgrid.nbsn;
    var1 = reshape(var1, node, []);
    varargin = read_varargin(varargin, {'List'}, {1:node});
    
elseif dims1(1) == nele
    around = fgrid.nbe;
    var1 = reshape(var1, nele, []);
    varargin = read_varargin(varargin, {'List'}, {1:nele});
    
else
    error('The first dimension of input should be either node or nele.')
end

var2 = var1;
for n = 1 : N
% Add the fake last element
var1(end+1, :) = nan;

for i = 1 : size(var1,2)
    var = var1(:,i);
    var_interp = nanmean(var(around), 2) * (1-CenterWeight) + var(1:end-1) * CenterWeight;
    
    % Find the nan in the original array
    k_nan = find(isnan(var(1:end-1)));
    % Keep them as nan
    var_interp(k_nan) = nan;

    var2(:,i) = var(1:end-1);
    var2(List, i) = var_interp(List);
end
    
var2 = reshape(var2, dims1);

end