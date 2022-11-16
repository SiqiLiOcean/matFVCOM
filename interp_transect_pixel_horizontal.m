%==========================================================================
% Interpolate the pixels on the transect on the horizontal
%
% input  : 
%          x, x coordinate of the section points (m or degree)
%          y, y coordinate of the section points (m or degree)
%          'npixel', 200 the pixel number on one direction (horizontal or
%                        vertical), default is 200.
%
% output : x_sec, x column for setion points (m or degree)
%          y_sec, y column for setion points (m or degree)
%          d_sec, distance column for setion points (m or degree)
%
% Siqi Li, SMAST
% 2021-06-21
%==========================================================================
function [x_sec, y_sec, d_sec] = interp_transect_pixel_horizontal(x, y, varargin)

% % Initiallization
% npixel=200;
% 
% k=1;
% % Pixel number
% while k<=length(varargin)
%     switch lower(varargin{k}(1:5))
%         case 'npixel'
%             npixel=varargin{k+1};
%     end
%     k=k+2;
% end
varargin = read_varargin(varargin, {'npixel'}, {200});
varargin = read_varargin2(varargin, {'Geo'});



% n=length(x);

d=sqrt((diff(x)).^2+(diff(y)).^2);

% Calculate the x, y coordinate of each transect points
x_sec=x(1);
y_sec=y(1);
for i=1:length(d)
    %
    x_tmp=linspace(x(i),x(i+1),max([ceil(d(i)/sum(d)*npixel),3]));
    y_tmp=linspace(y(i),y(i+1),max([ceil(d(i)/sum(d)*npixel),3]));
    %
    x_sec=[x_sec;x_tmp(2:end)'];
    y_sec=[y_sec;y_tmp(2:end)'];
end
  
% Calculate the distance to the first point along the transect line.
% d_sec=0;
% for i=2:length(x_sec)
%     d=sqrt((x_sec(i)-x_sec(i-1))^2+(y_sec(i)-y_sec(i-1))^2);
%     d_sec=[d_sec;d_sec(i-1)+d];
% end

if Geo
    d_sec = calc_distance(x_sec, y_sec, x_sec(1), y_sec(1), 'Geo');
else
    d_sec = calc_distance(x_sec, y_sec, x_sec(1), y_sec(1));
end

d_sec = d_sec / 1000;

end