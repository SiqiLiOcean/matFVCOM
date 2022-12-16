%==========================================================================
%
% input  :
%
% output :
%
% Siqi Li, SMAST
% 2021-07-20
%
% Example:
%
% cm2 = flip(cm_load('blues'));
% plane_topo('xlims', xlims, 'ylims', ylims, 'Patch', ...
%            'Color', [.8 .8 .8], ...
%            'Levels', [1000:1000:4000]);
% colormap(cm2);
% 
% Updates:
%
%==========================================================================
function [C, h, Data] = plane_topo(varargin)

PATH = set_path;

varargin = read_varargin(varargin, ...
            {'FontSize', 'LabelSpacing', 'Color'}, ...
            {        12,           300,     'k'});
varargin = read_varargin(varargin, {'Levels'}, {[]});

varargin = read_varargin(varargin, {'xlims', 'ylims'}, {[-180 180], [-90 90]});
varargin = read_varargin(varargin, {'n'}, {600});

varargin = read_varargin2(varargin, {'Patch'});

varargin = read_varargin2(varargin, {'Manual'});     
varargin = read_varargin2(varargin, {'NoLabel'});
varargin = read_varargin(varargin, {'Data'}, {[]});


% patch_color = [222,184,135]/255;   % tan

if isempty(Data)

%     if contains(computer, 'WIN')
%         etopo_path = 'C:\data\ETOPO1_Bed_g_gmt4.grd';
%     else
%         etopo_path = [fundir('plane_topo') 'data/ETOPO1_Bed_g_gmt4.grd'];
%     end
    etopo_path = PATH.etopo1;

    % Read the etopo coastline data
    x0 = -180 : 1/60 : 180;
    y0 =  -90 : 1/60 :  90;
    % x0 = -180 : 1/30 : 180;
    % y0 =  -90 : 1/30 :  90;

    ix = find(x0>xlims(1) & x0<xlims(2));
    iy = find(y0>ylims(1) & y0<ylims(2));

    ix1 = max([ix(1)-1 1]);
    ix2 = min([ix(end)+1 length(x0)]);
    nx = ix2 - ix1 + 1;
    iy1 = max([iy(1)-1 1]);
    iy2 = min([iy(end)+1 length(y0)]);
    ny = iy2 - iy1 + 1;

    [yy0, xx0] = meshgrid(y0(iy1:iy2), x0(ix1:ix2));
    z0 = -ncread(etopo_path, 'z', [ix1 iy1], [nx ny]);

    xl = linspace(xlims(1), xlims(2), n);
    yl = linspace(ylims(1), ylims(2), n);
    [yy, xx] = meshgrid(yl, xl);
    zz = griddata(xx0, yy0, z0, xx, yy);

    Data = {xx, yy, zz};

else
    xx = Data{1};
    yy = Data{2};
    zz = Data{3};
end

if Patch
    h = pcolor(xx, yy, zz);
    set(h, 'linestyle', 'none')
% % 
% %     [C, h] = contour(xx, yy, zz);
% %     set(h, 'linecolor', Color)
% %     clabel(C, h, 'FontName', 'Times new Roman', ...
% %                  'fontsize',FontSize, ...
% %                  'LabelSpacing', LabelSpacing, ...
% %                  'Color', Color);
    C = [];
    return
end


if isempty(Levels)
    [C, h] = contour(xx, yy, zz);
else
    [C, h] = contour(xx, yy, zz, Levels);
end

set(h, 'linecolor', Color)

if ~NoLabel
    
    if Manual
        clabel(C, h, 'manual', ...
            'fontsize',FontSize, ...
            'Color', Color);
    else
        clabel(C, h, 'fontsize',FontSize, ...
            'LabelSpacing', LabelSpacing, ...
            'Color', Color);
    end
end

         
if (~isempty(varargin))
    set(h, varargin{:});
end

% % 
% % box = [xlims(1) ylims(1);
% %     xlims(2) ylims(1);
% %     xlims(2) ylims(2);
% %     xlims(1) ylims(2);
% %     xlims(1) ylims(1)];
% % coast0 = [[data(:).Lon]' [data(:).Lat]'];
% % 
% % 
% % % % Rotate
% % % [box(:,1), box(:,2)] = rotate_theta(box(:,1), box(:,2), -fgrid.rotate);
% % % [coast0(:,1), coast0(:,2)] = rotate_theta(coast0(:,1), coast0(:,2), -fgrid.rotate);
% % 
% % poly_box = polyshape(box);
% % poly_coast0 = polyshape(coast0);
% % 
% % poly_coast = intersect(poly_box, poly_coast0);
% % 
% % 
% % 
% % h = plot(poly_coast);
% % set(h, 'LineStyle', 'none')
% % set(h, 'FaceColor', patch_color)
% % set(h, 'FaceAlpha', 1)
% % 
