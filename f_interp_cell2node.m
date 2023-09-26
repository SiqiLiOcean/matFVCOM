%==========================================================================
% matFVCOM package
%   Interpolate FVCOM data from cell to grid
%
% input  :
%   fgrid
%   var1   : source data
% 
% output :
%   var2   : destination data
%
% Siqi Li, SMAST
% 2023-09-26
%
% Updates:
%
%==========================================================================
function var2 = f_interp_cell2node(fgrid, var1)

node = fgrid.node;
nele = fgrid.nele;

% if isfield(fgrid, 'nbve')
    nbve = fgrid.nbve;
% else
%     disp('Calculate NBVE first...')
%     nbve = f_calc_nbve(fgrid);
%     fgrid.nbve = nbve;
% %     eval([inputname(1) '.nbve = nbve;'])
% %     assignin('base', [inputname(1) '.nbve'], nbve)
%     assignin('caller', inputname(1), fgrid)
% end


dims1 = size(var1);

% Find the dimension of nele
if dims1(1)~=nele
    error('The size of input var1 is wrong.')
end

% Output dimensions
dims2 = dims1;
dims2(1) = node;


v1 = reshape(var1, nele, []);
% Add a group of fake numbers in the first dimension
v1(nele+1, :) = nan;

nslide = size(v1, 2);
v2 = nan(node, nslide);
for i = 1 : nslide
    v2(:,i) = mean(reshape(v1(nbve,i),fgrid.node,[]), 2, 'omitnan');
end

var2 = reshape(v2, dims2);

