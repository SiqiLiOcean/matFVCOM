%==========================================================================
% Calculate the isoline of one certain level
% 
% Input  : --- wgrid
%          --- var, input variable (in the size of node or cell)
%          --- level, the level of isoline
%
% Output : --- level_x, x of isolines
%          --- level_y, y of isolines
% 
% Usage  : [x, y] = w_isoline(w, u, -10);
%
% v1.0
%
% Siqi Li
% 2021-06-21
%
% Updates:
%
%==========================================================================
function [level_x, level_y] = w_isoline(wgrid, var, level)

if length(level(:)) > 1
    error('The input level should be one number.')
end

% var = u;
% wgrid = w;
% level = -10;

x = wgrid.x;
y = wgrid.y;
nx = wgrid.nx;
ny = wgrid.ny;

var = double(var);



dims = size(var);
if dims(1) == nx && dims(2) == ny
    % variable on M grid
elseif dims(1) == nx+1 && dims(2) == ny
    % variable on U grid
    var = w_interp_UV2M(wgrid, var);
elseif dims(1) == nx && dims(2) == ny+1
    % variable on U grid
    var = w_interp_UV2M(wgrid, var);
else
    error('The input var size is wrong')
end

C = contourc(var, [level level]);

k = [];
level_x = [];
level_y = [];
% z = [];
i1 = 1;
[JJ, II] = meshgrid(1:ny, 1:nx);
while i1<size(C,2)
    k = [k; i1];
    
    i2 = i1 + C(2,i1)+1;
    
    J = C(1,i1+1:i2-1);
    I = C(2,i1+1:i2-1);
%     tmp_x = interp_bilinear(II, JJ, x, I, J);
%     tmp_y = interp_bilinear(II, JJ, y, I, J);
    tmp_x = griddata(II, JJ, x, I, J);
    tmp_y = griddata(II, JJ, y, I, J);
    
    level_x = [level_x nan tmp_x(:)'];
    level_y = [level_y nan tmp_y(:)'];
%     z = [z C(1,i1)];
    i1 = i2;
end
