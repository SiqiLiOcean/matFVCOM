%==========================================================================
% Calculate node or cell list around the given transect
%
% input  :
%   fgrid
%   x0
%   y0
%   'npixel'
%   'Type' 
% 
% output :
%
% Siqi Li, SMAST
% 2021-12-16
%
% Updates:
% 2022-06-08  Siqi Li  Fixed the bug that the transect could be out of 
%                      domain.
%==========================================================================
function [list, x_sec, y_sec, d_sec] = f_calc_transect_neighbor(fgrid, x0, y0, varargin)


varargin = read_varargin(varargin, {'npixel'}, {200});
varargin = read_varargin(varargin, {'Type'}, {'Node'});
% 
% fgrid = f1;
% npixel = 200;

x0 = x0(:);
y0 = y0(:);
nv = fgrid.nv;
nbve = fgrid.nbve;

% Add the intersec points into (x0, y0)
[xi, yi, ii] = polyxpoly([fgrid.bdy_x{:}], [fgrid.bdy_y{:}], x0, y0);
for i = size(ii,1) : -1 :1
    a = ii(i,2);
    x0 = [x0(1:a); xi(i); x0(a+1:end)];
    y0 = [y0(1:a); yi(i); y0(a+1:end)];
end

% Interpolate the water depth onto the section
[h_sec, x_sec, y_sec, d_sec] = f_interp_transect(fgrid, fgrid.h, x0, y0, 'npixel', npixel);

% % figure
% % hold on
% % f_2d_mesh(f1)
% % f_2d_cell(fgrid, list_cell, 'Patch')
% % plot(x_sec, y_sec, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 8)


cell_id = f_find_cell(fgrid, x_sec, y_sec);
list_node = nv(cell_id(~isnan(cell_id)), :);
list_node = sort(unique(list_node(:)));

switch lower(Type)
    case 'node'
        list = list_node;
        
    case 'cell'
        list_cell = nbve(list_node, :);
        list_cell = sort(unique(list_cell(:)));
        if list_cell(end) == fgrid.nele+1
            list_cell(end) = [];
        end
        list = list_cell;
        
    otherwise
        error(['Unknown Type. Select Node or Cell'])
end
    
    
