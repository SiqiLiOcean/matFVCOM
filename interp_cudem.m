%==========================================================================
% matFVCOM package
%   Interpolate depth from CUDEM dataset
%
% input  :
%   demdir
%   x
%   y
%   'Extrap' --- (Optional) extrapolation method, 'NAN', 'NEAREST', 'LINEAR'
% output :
%   depth --- negative for water (m)
%
% Siqi Li, SMAST
% 2023-06-02
%
% Updates:
%
%==========================================================================
function h = interp_cudem(demdir, x, y, varargin)

varargin = read_varargin(varargin, {'Extrap'}, {'NAN'});
varargin = read_varargin(varargin, {'Min'}, {-Inf});
varargin = read_varargin(varargin, {'Max'}, {Inf});




files = dir([demdir '/*.tif']);
h = nan(length(x), 1);
for i = 1 : length(files)
    disp([num2str(i, '%3.3d') '/' num2str(length(files), '%3.3d') ' : ' files(i).name])
    fin = [files(i).folder '/' files(i).name];
    [x0, y0, z0] = read_tiff(fin);
    x0 = x0(:,1);
    y0 = y0(1,:);
    xlims = minmax(x0);
    ylims = minmax(y0);
%     z0 = -z0;
    in = x>=xlims(1) & x<=xlims(2) & y>=ylims(1) & y<=ylims(2);
    if sum(in) == 0
        continue
    end
    z0(z0<Min) = nan;
    z0(z0>Max) = nan;
    h(in) = interp_2d(z0, 'BI', x0(:), y0(:), x(in), y(in));
end

switch upper(Extrap)
    case 'NAN'
        % Nothing to do
    case 'NEAREST'
        i_nan = find(isnan(h));
        i_num = find(~isnan(h));
        k = ksearch([x(i_num) y(i_num)], [x(i_nan) y(i_nan)]);
        h(i_nan) = h(i_num(k));
    case 'LINEAR'
        i_nan = find(isnan(h));
        i_num = find(~isnan(h));

        F = scatteredInterpolant(x(i_num), y(i_num), h(i_num));
        h(i_nan) = F(f1.x(i_nan), f1.y(i_nan));
end



