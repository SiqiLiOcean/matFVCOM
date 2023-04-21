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
varargin = read_varargin(varargin, {'Margin'}, {[]});


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
        
if numel(x)==numel(y) && numel(x)==numel(z)
    x = x(:);
    y = y(:);
    z = z(:);
    xlims = minmax(x);
    ylims = minmax(y);
    xl = linspace(xlims(1), xlims(2), nPixel);
    yl = linspace(ylims(1), ylims(2), nPixel);
    [yy, xx] = meshgrid(yl, xl);
    zz = griddata(x, y, z, xx, yy);
else
    xl = x(:);
    yl = y(:);
    zz = z;
end


if length(levels) == 1
    levels = [levels levels];
end

if ~isempty(Margin)
    x1 = xl(1)*2 - xl(2);
    y1 = yl(1)*2 - yl(2);
    x2 = xl(end)*2 - xl(end-1);
    y2 = yl(end)*2 - yl(end-1);
    xl = [x1; xl; x2];
    yl = [y1; yl; y2];
    ztmp = zz;
    zz = Margin * ones(length(xl), length(yl));
    zz(2:end-1, 2:end-1) = ztmp;
end
    


C = contourc(xl, yl, zz', levels);


if isempty(C)
    L = [];
else
    L = read_contourC(C, 'MinLength', MinLength);
end
    