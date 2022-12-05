%==========================================================================
% Example of doing the velocity projection from Cartisian Coordinate to
% Geographic Coordinate.
%
% call the matlab function UV_projection.m
%
% Siqi Li, SMAST
% 2021-06-15
%==========================================================================


clc
clear

% FVCOM NetCDF output file path and name
file = './gom3_grid.nc';

% Read the mesh information
x = ncread(file, 'x');
y = ncread(file, 'y');
nv = ncread(file, 'nv');
lon = ncread(file, 'lon');
lat = ncread(file, 'lat');

% Read the u and v
u = ncread(file, 'u');
v = ncread(file, 'v');


% Projection from Cartisian Coordinate to Geographic Coordinate.
[uE, vN] = UV_projection(x, y, nv, lon, lat, u, v);


% % Plot
% close all
% figure
% %
% subplot(2,3,1)
% box on
% patch('Vertices',[lon,lat], 'Faces',nv, ...
%     'FaceColor','flat', 'FaceVertexCData',u, 'EdgeColor','none');
% colorbar
% caxis([-2 2])
% axis tight
% title('u (m/s)')
% %
% subplot(2,3,2)
% box on
% patch('Vertices',[lon,lat], 'Faces',nv, ...
%     'FaceColor','flat', 'FaceVertexCData',uE, 'EdgeColor','none');
% colorbar
% caxis([-2 2])
% axis tight
% title('uE (m/s)')
% %
% subplot(2,3,3)
% box on
% patch('Vertices',[lon,lat], 'Faces',nv, ...
%     'FaceColor','flat', 'FaceVertexCData',uE-u, 'EdgeColor','none');
% colorbar
% caxis([-0.15 0.15])
% axis tight
% title('uE-u (m/s)')
% 
% %
% subplot(2,3,4)
% box on
% patch('Vertices',[lon,lat], 'Faces',nv, ...
%     'FaceColor','flat', 'FaceVertexCData',v, 'EdgeColor','none');
% colorbar
% caxis([-2 2])
% axis tight
% title('v (m/s)')
% %
% subplot(2,3,5)
% box on
% patch('Vertices',[lon,lat], 'Faces',nv, ...
%     'FaceColor','flat', 'FaceVertexCData',vN, 'EdgeColor','none');
% colorbar
% caxis([-2 2])
% axis tight
% title('vN (m/s)')
% %
% subplot(2,3,6)
% box on
% patch('Vertices',[lon,lat], 'Faces',nv, ...
%     'FaceColor','flat', 'FaceVertexCData',vN-v, 'EdgeColor','none');
% colorbar
% caxis([-0.15 0.15])
% axis tight
% title('vN-v (m/s)')
% 
% colormap(jet)
% set(gcf, 'position', [29 162 1616 815])
