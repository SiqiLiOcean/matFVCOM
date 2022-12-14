%==========================================================================
% Calculate the direction of each cell: clockwise or counter clockwise
% 
% Input  : --- fgrid
%                OR
%          --- x,      x coordinate on node, (node)
%          --- y,      y coordinate on node, (node)
%          --- nv,     id of nodes around cells, (nele, 3)
%         
% Output : --- tf, clockwise (1) or counter clockwise (-1)
% 
% Usage  : tf = f_calc_grid_direction(f);
%              OR
%          tf = f_calc_grid_direction(x, y, nv);
% v1.0
%
% Siqi Li
% 2021-04-13
%
% Updates:
%
%==========================================================================
function [tf, nv] = f_calc_grid_direction(varargin)

varargin = read_varargin2(varargin, {'Fix'});


switch class(varargin{1})
    case 'struct'
        fgrid = varargin{1};
        x = fgrid.x;
        y = fgrid.y;
        nv = fgrid.nv;
        nele = fgrid.nele;
    case {'single', 'double'}
        x = double(varargin{1});
        y = double(varargin{2});
        nv = varargin{3};
        nele = size(nv, 1);
    otherwise
        error('Input should be either fvcom grid cell or x, y, nv')
end



px = x(nv);
py = y(nv);

cross_prod = (px(:,3)-px(:,1)).*(py(:,2)-py(:,1)) - ...
             (px(:,2)-px(:,1)).*(py(:,3)-py(:,1)) ;
         
tf = max(sign(cross_prod), 0);

disp('')
disp('------------------------------------------------')
if sum(tf==1)==nele
    disp('All nodes are in clock-wise order.')
    disp('(Used in FVCOM simulation and Netcdf file)')
%     disp('Now modify it in counter clock-wise order.')
%     nv = nv(:,[1 3 2]);
elseif sum(tf==0)==nele
    disp('All nodes are in counter clock-wise order.')
    disp('(Used in 2dm and FVCOM grd input.)')
%     nv = nv(:,[1 3 2]);
else
    disp('Some nodes are in clock-wise and some not.')
%     disp('Now modify it in counter clock-wise order.')
%     nv(tf==1, :) = nv(tf==1, [1 3 2]);
end

if ~isempty(Fix) && any(tf)
    nv(tf==1, :) = nv(tf==1, [1 3 2]);
end

disp('------------------------------------------------')
disp('')








% Use the MATLAB ispolycw.
% This method is slow.
% tf = nan(nele, 1);
% for i = 1 : nele
%     tf(i) = ~ispolycw(px(i,:), py(i,:));
% end

% if sum(tf==0)==nele
%     disp('All nodes are in clock-wise order.')
%     disp('(Used in FVCOM simulation and Netcdf file)')
% elseif sum(tf==1)==nele
%     disp('All nodes are in counter clock-wise order.')
%     disp('(Used in 2dm and FVCOM grd input.)')
% else
%     disp('Some nodes are in clock-wise and some not.')
%     disp('The nv needs to be re-set.')
% end