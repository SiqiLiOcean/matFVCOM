%==========================================================================
% Calculate the resolution of FVCOM grd
%
% input  : x  (x coordinate)
%          y  (y coordinate)
%          nv (triangle matrix)
%          (The variables above will be got from fgrid)
% output : d_cell (mean resolution on cell center of the three edges)
%          d      (length of every line, in shape of (nele,3))
%
% Siqi Li, SMAST
% 2020-07-16
%==========================================================================
function [d_cell, d] = f_calc_resolution(varargin)


varargin = read_varargin2(varargin, {'Geo'});
varargin = read_varargin(varargin, {'R'}, {6371e3}');


switch class(varargin{1})
    
    case 'struct'
        fgrid = varargin{1};
        
        x = fgrid.x;
        y = fgrid.y;
        nv = fgrid.nv;
        
    otherwise
        x = varargin{1};
        y = varargin{2};
        nv = varargin{3};
        
end


px = x(nv);
py = y(nv);

if Geo
    d = calc_distance(px(:,[1 2 3]), py(:,[1 2 3]), px(:,[2 3 1]), py(:,[2 3 1]), 'Geo', 'R', R);
else
    d = sqrt( (px - px(:, [2 3 1])).^2 + (py - py(:, [2 3 1])).^2 );
end

d_cell = mean(d, 2);


disp(' ')
disp('------------------------------------------------')
fprintf(' Resolution: %f ~ %f \n', min(min(d_cell)), max(max(d_cell)))
disp('------------------------------------------------')
disp(' ')