%==========================================================================
% Save the image to kmz file
%
% input  :
%   f    ---
%   var  ---
%   fkmz ---
%
% output :
%
% Siqi Li, SMAST
% 2022-12-21
%
% Updates:
%
%==========================================================================
function f_kml_image(f, var, fkmz, varargin)

varargin = read_varargin(varargin, {'zlims'}, {minmax(var)});
varargin = read_varargin(varargin, {'cm'}, {get(0, 'DefaultFigureColormap')});
varargin = read_varargin(varargin, {'Model'}, {'Model'});
varargin = read_varargin(varargin, {'NPixel'}, {600});


if length(var) == fgrid.node
    x = f.x;
    y = f.y;
elseif length(var) == fgrid.nele
    x = f.xc;
    y = f.yc;
else
    error('Wrong input size.')
end

[xlims, ylims] = f_2d_range(fgrid);

xl = linspace(xlims(1), xlims(2), NPixel);
yl = linspace(ylims(1), ylims(2), NPixel);

[yy, xx] = meshgrid(yl, xl);
zz = griddata(x, y, var, xx, yy);

% Maske the pixels outside
in = inpolygon(xx, yy, [fgrid.bdy_x{:}], [fgrid.bdy_y{:}]);
zz(~in) = nan;
var = zz;

var = var(:, end:-1:1)';
[ny, nx] = size(var);

ncolor = size(cm, 1);
cm(end+1, :) = [1 1 1];

dd = (zlims(2) - zlims(1)) / ncolor;
ic = ceil((var - zlims(1)) / dd);
ic(ic==0) = 1;
ic(ic>ncolor) = ncolor;
ic(isnan(ic)) = ncolor + 1;

A = reshape(cm(ic,:), ny, nx, 3);
alpha = ones(ny, nx);
alpha(ic == ncolor+1) = 0;

% Save the figure
imwrite(A, 'figure.png', 'alpha', alpha);

% Save the colorbar
hf = figure('Position', [1 1 200 140], 'Visible', 'off');
ax = axes;
cb = colorbar(ax);
cb.FontSize = 5;
caxis(zlims)
ax.Visible = 'off';
cb.TickDirection = 'out';
mf_save('colorbar.png', 'Resolution', 300);
close(hf);
A_cb = imread('colorbar.png');
ny_cb = size(A_cb,1);
nx_cb = size(A_cb,2);
ypixel_cb = num2str(400);
xpixel_cb = num2str(ypixel_cb/ny_cb*nx_cb); 

% Save the kml
fid = fopen('doc.kml', 'w');
fprintf(fid, '%s\n', '<?xml version="1.0" encoding="UTF-8"?>');
fprintf(fid, '%s\n', '<kml xmlns="http://www.opengis.net/kml/2.2"> ');
fprintf(fid, '%s\n', '<Document>');
fprintf(fid, '%s\n', ['<name>' Model '</name>']);
fprintf(fid, '%s\n', '<ScreenOverlay>');
fprintf(fid, '%s\n', '<name>Colorbar</name>');
fprintf(fid, '%s\n', '<visibility>1</visibility>');
fprintf(fid, '%s\n', '<Icon>');
fprintf(fid, '%s\n', '<href>colorbar.png</href>');
fprintf(fid, '%s\n', '</Icon>');
fprintf(fid, '%s\n', '<overlayXY x="0" y="0" xunits="fraction" yunits="fraction"/>');
fprintf(fid, '%s\n', '<screenXY x="0" y="0" xunits="fraction" yunits="fraction"/>');
fprintf(fid, '%s\n', '<rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>');
fprintf(fid, '%s\n', ['<size x="' xpixel_cb '" y="' ypixel_cb '" xunits="pixels" yunits="pixels"/>']);
fprintf(fid, '%s\n', '</ScreenOverlay>');
fprintf(fid, '%s\n', '<GroundOverlay>');
fprintf(fid, '%s\n', '<name>Figure</name>');
fprintf(fid, '%s\n', '<visibility>1</visibility>');
fprintf(fid, '%s\n', '<Icon>');
fprintf(fid, '%s\n', '<href>figure.png</href>');
fprintf(fid, '%s\n', '</Icon>');
fprintf(fid, '%s\n', '<LatLonBox>');
fprintf(fid, '%s\n', ['<north>' num2str(ylims(2)) '</north>']);
fprintf(fid, '%s\n', ['<south>' num2str(ylims(1)) '</south>']);
fprintf(fid, '%s\n', ['<east>' num2str(xlims(1)) '</east>']);
fprintf(fid, '%s\n', ['<west>' num2str(xlims(2)) '</west>']);
fprintf(fid, '%s\n', '</LatLonBox>');
fprintf(fid, '%s\n', '</GroundOverlay>');
fprintf(fid, '%s\n', '</Document>');
fprintf(fid, '%s\n', '</kml>');
fclose(fid);


zip([fkmz '.zip'], {'figure.png', 'colorbar.png', 'doc.kml'});
movefile([fkmz '.zip'], fkmz);
delete('doc.kml');
delete('figure.png');
delete('colorbar.png');


