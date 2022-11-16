%==========================================================================
% Draw WRF mesh
% 
% Input  : --- wgrid, WRF grid cell 
%          --- varargin, settings for the plot figure
%
% Output : --- h, figure handle
% 
% Usage  : h = w_2d_mesh(wgrid);
%
% v1.0
%
% Siqi Li
% 2021-05-11
%
% Updates:
%
%==========================================================================
function h = w_2d_mesh(wgrid, varargin)

varargin = read_varargin(varargin, {'Color'}, {'k'});

x = wgrid.x;
y = wgrid.y;
nv = wgrid.nv;


h = patch('Vertices',[x(:),y(:)], 'Faces',nv, 'FaceColor','k','FaceAlpha',0, 'EdgeColor', Color);


% i = 1;
% while i<=length(varargin)
%     switch lower(varargin{i})
%         case 'color'
%             c = varargin{i+1};
%             switch class(varargin{i+1})
%                 case 'char'
%                     if strcmp(varargin{i+1}, 'w') || strcmp(varargin{i+1}, 'white')
%                         c = [254 254 254]/255;
%                     end
%                 case 'double'
%                     if varargin{i} == [1 1 1]
%                         c = [254 254 254]/255;
%                     end
%             end
%             set(h, 'EdgeColor', c)
%             varargin(i:i+1) = [];
%             i = i - 2;
%             
%     end
%             
%     i = i + 2;
% end



% lon = wgrid.lon;
% lat = wgrid.lat;
% [nx, ny] = size(lon);
% 
% 
% lon1 = lon;
% lat1 = lat;
% lon1(nx+1, :) = nan;
% lat1(nx+1, :) = nan;
% 
% lon2 = lon';
% lat2 = lat';
% lon2(ny+1, :) = nan;
% lat2(ny+1, :) = nan;
% 
% lon_plot = [lon1(:); lon2(:)];
% lat_plot = [lat1(:); lat2(:)];
% 
% h = plot(lon_plot, lat_plot, 'k-');

if ~isempty(varargin)
    set(h, varargin{:});
end