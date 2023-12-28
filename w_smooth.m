%==========================================================================
% Smooth the WRF field 
% input  : 
%   ---wgrid
%   ---var1
%   ---'List'
%   ---'K'
%
% output :
%   ---var2
%
% Siqi Li, SMAST
% 2021-07-02
%
% Updates:
%
%==========================================================================
function var2 = w_smooth(wgrid, var1, varargin)

nx = wgrid.nx;
ny = wgrid.ny;

varargin = read_varargin(varargin, {'K'}, {3});
varargin = read_varargin(varargin, {'List'}, {1:nx*ny});


dims1 = size(var1);


var1 = reshape(var1, nx, ny, []);
nslice = size(var1, 3);


Kmat = (1/K/K) * ones(K);


for i = 1 : nslice
    
    var_slice = var1(:,:,i);
    var_conv2 = conv2(var_slice, Kmat, 'same');
    
    var_slice(List) = var_conv2(List);
    
    var2(:,:,i) = var_slice;
    
end

var2 = reshape(var2, dims1);

