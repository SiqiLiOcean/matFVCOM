%==========================================================================
% Overlay the current figure onto Google Earth
%
% input  : fgrid --- FVCOM grid cell
%          model --- string to show the model name
%          fout  --- output path and name
%          'linewidth' --- line width
%          'linecolor' --- line color ('r' or [255 0 0])
% 
% output : \
%
% Siqi Li, SMAST
% 2021-06-09
%
% Updates:
%
%==========================================================================
function kml_overlay(fout)

% Get the file names
k = strfind(fout, '.kmz');
if isempty(k)
    name = fout;
else
    name = fout(1:k(end)-1);
end
fkmz = [name '.kmz'];
fpng = [name '.png'];


% First make the figure invisible
set(gcf, 'Visible', 'off')


xlims = xlim;
ylims = ylim;
xrange = xlims(2) - xlims(1);
yrange = ylims(2) - ylims(1);
set(gcf, 'position', [1 1 1000 round(1000/xrange*yrange)])

% Remove the axis
set(gca, 'Visible','off')

% Remove the margin
set(gca, 'position', [0 0 1 1])

% Save the file for the first time
print(fpng, '-dpng', '-r300')


% Set the outer region as transparent
cmat = imread(fpng);
bgColor = get(gca, 'color');
axc = ceil(bgColor*255);
alphaMap = uint8(~(cmat(:,:,1)==axc(1) & cmat(:,:,2)==axc(2) & cmat(:,:,3)==axc(3))*255);
imwrite(cmat, fpng, 'Alpha', alphaMap);

% Set the colorbar
cb = get(ancestor(gca, 'axes'), 'colorbar');

k = kml('Overlay');
k.overlay(xlims(1), xlims(2), ylims(1), ylims(2), 'file', fpng, 'altitude', 0);
if ~isempty(cb)
    cAxis = caxis;
    colorMap = colormap;
    k.colorbar(cAxis, colorMap)
end
k.save(fkmz);
% k.run;

close
delete(fpng)
delete('Colorbar.png')

set(gcf, 'Visible', 'on')
close