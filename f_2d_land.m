%==========================================================================
% Patch the FVCOM grid land
%
% input  : x   (x coordinate)
%          y   (y coordinate)
%          nv  (triangle matrix)
%          (The variables above will be got from fgrid)
% output : h (figure handle)
%
% Siqi Li, SMAST
% 2021-03-10
%==========================================================================
function h = f_2d_land(fgrid, varargin)

varargin = read_varargin(varargin, {'xlims'}, {minmax(fgrid.x)});
varargin = read_varargin(varargin, {'ylims'}, {minmax(fgrid.y)});
varargin = read_varargin(varargin, {'Cut'}, {[]});


tan = [214 181 137] / 255;


pg_frame = polyshape(xlims([1 2 2 1 1]), ylims([1 1 2 2 1]));
pg_bdy = polyshape(fgrid.bdy_x, fgrid.bdy_y);
pg_out = subtract(pg_frame, pg_bdy);

if ~isempty(Cut)
    pg_cut = polyshape(Cut(:,1), Cut(:,2));
    pg_out = subtract(pg_out, pg_cut);
end


h = plot(pg_out, 'EdgeColor', 'none', ...
                 'FaceColor', tan, ...
                 'FaceAlpha', 1);

if ~isempty(varargin)
    set(h, varargin{:});
end


