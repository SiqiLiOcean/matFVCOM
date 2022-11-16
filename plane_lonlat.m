%==========================================================================
% 
% input  : 
% 
% output :
%
% Siqi Li, SMAST
% 2021-07-22
%
% Updates:
%
%==========================================================================
function [h1, h2] = plane_lonlat(varargin)

if isempty(get(gcf,'Children'))
    error('Draw the axes first')
end

varargin = read_varargin(varargin, {'Stride', 'Style'}, {1, 1});

xlims = get(gca, 'xlim');
ylims = get(gca, 'ylim');

x = floor(xlims(1)) : Stride : ceil(xlims(2));
y = floor(ylims(1)) : Stride : ceil(ylims(2));

kx = x>=xlims(1) & x<=xlims(2);
ky = y>=ylims(1) & y<=ylims(2);

xtick = x(kx);
ytick = y(ky);



n_xtick = length(xtick);
n_ytick = length(ytick);


switch Style
    case 1
        XTickLabel = num2str(abs(xtick(:)));
        YTickLabel = num2str(abs(ytick(:)));
    case 2
        XTickLabel = num2str(xtick(:));
        YTickLabel = num2str(ytick(:));
    case 3
        E = repmat('E', n_xtick, 1);
        E(xtick<0) = 'W';
        E(xtick==0) = ' ';
        N = repmat('N', n_ytick, 1);
        N(ytick<0) = 'S';
        N(ytick==0) = ' ';
        XTickLabel = [num2str(abs(xtick(:))) E];
        YTickLabel = [num2str(abs(ytick(:))) N];
    case 4
        XTickLabel = [num2str(abs(xtick(:))) repmat('^o', n_xtick, 1)];
        YTickLabel = [num2str(abs(ytick(:))) repmat('^o', n_ytick, 1)];
    case 5
        XTickLabel = [num2str(xtick(:)) repmat('^o', n_xtick, 1)];
        YTickLabel = [num2str(ytick(:)) repmat('^o', n_ytick, 1)];
    case 6
        E = repmat('^oE', n_xtick, 1);
        E(xtick<0,3) = 'W';
        E(xtick==0,3) = ' ';
        N = repmat('^oN', n_ytick, 1);
        N(ytick<0,3) = 'S';
        N(ytick==0,3) = ' ';
        XTickLabel = [num2str(abs(xtick(:))) E];
        YTickLabel = [num2str(abs(ytick(:))) N];    
    otherwise
        error('Unkown Style')
end


set(gca, 'xtick', xtick);
set(gca, 'ytick', ytick);
set(gca, 'xticklabel', XTickLabel);
set(gca, 'yticklabel', YTickLabel);





