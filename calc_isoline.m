%==========================================================================
% Calculate the isolines from 2d fields.
%
% input  :
%   xl   ---
%   yl
%   zz
%   levels
% 
% output :
%
% Siqi Li, SMAST
% yyyy-mm-dd
%
% Updates:
%
%==========================================================================
function  L = calc_isoline(x, y, z, levels, varargin)

varargin = read_varargin(varargin, {'nPixel'}, {400});
varargin = read_varargin(varargin, {'MinLength'}, {4});


% % if  length(x) == numel(x)   % 1d mesh
% %     xl = x;
% %     yl = y;
% %     zz = z;
% %     
% % else                        % 2d mesh
% %     if sum(x(1,:)==x(end,:)) && sum(y(:,1)==y(:,end))
% %         xl = x(1,:);
% %         yl = y(:,1);
% %         zz = z;
% %         
% %     elseif sum(y(1,:)==y(end,:)) && sum(x(:,1)==x(:,end))
% %         xl = x(:,1);
% %         yl = y(1,:);
% %         zz = z;
% %         
% %     else
% %         xlims = minmax(x);
% %         ylims = minmax(y);
% %         xl = linspace(xlims(1), xlims(2), nPixel);
% %         yl = linspace(ylims(1), ylims(2), nPixel);
% %         [yy, xx] = meshgrid(yl, xl);
% %         zz = griddata(x(:), y(:), z(:), xx, yy);
% %         
% %     end
% %     
% % end
        
x = x(:);
y = y(:);
z = z(:);
xlims = minmax(x);
ylims = minmax(y);
xl = linspace(xlims(1), xlims(2), nPixel);
yl = linspace(ylims(1), ylims(2), nPixel);
[yy, xx] = meshgrid(yl, xl);
zz = griddata(x, y, z, xx, yy);
        

if length(levels) == 1
    levels = [levels levels];
end

C = contourc(xl, yl, zz', levels);


if isempty(C)
    L = [];
else
    L = read_contourC(C, 'MinLength', MinLength);
end
    