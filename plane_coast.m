%==========================================================================
%
% input  :
%
% output :
%
% Siqi Li, SMAST
% 2021-07-20
%
% Updates:
%
%==========================================================================
function [h, Data] = plane_coast(varargin)

varargin = read_varargin(varargin, {'xlims', 'ylims'}, {[-180 180], [-90 90]});
varargin = read_varargin(varargin, {'Resolution'}, {'i'});
varargin = read_varargin(varargin, {'Data'}, {[]});


patch_color = [222,184,135]/255;   % tan

if isempty(Data)

    Resolution = lower(Resolution);
    if sum(ismember('clih', Resolution)) ~= 1
        error('Unknown resolution. Options: c, l, i, h, f');
    end

    % gshhs_path = [fundir('plane_coast') 'data\gshhs_' Resolution '.b'];
    % gshhs_index = [fundir('plane_coast') 'data\gshhs_' Resolution '.i'];
    if contains(computer, 'WIN')
        gshhs_path = ['D:\data' '\gshhs_' Resolution '.b'];
        gshhs_index = ['D:\data' '\gshhs_' Resolution '.i'];
    else
        gshhs_path = [fundir('plane_coast') 'data/gshhs_' Resolution '.b'];
        gshhs_index = [fundir('plane_coast') 'data/gshhs_' Resolution '.i'];
    end

    % if contains(computer, 'WIN')
    %     k = strfind(gshhs_path, '\');
    %     gshhs_path = [gshhs_path(1:k(end)) 'data\gshhs_' Resolution '.b'];
    %     gshhs_index = [gshhs_path(1:k(end)) 'data\gshhs_' Resolution '.i'];
    % else
    %     k = strfind(gshhs_path, '/');
    %     gshhs_path = [gshhs_path(1:k(end)) 'data/gshhs_' Resolution '.b'];
    %     gshhs_index = [gshhs_path(1:k(end)) 'data/gshhs_' Resolution '.i'];
    % end

    % Read the gshhs coastline data
    if ~isfile(gshhs_index)
        disp(['Creating in gshhs ' Resolution ' index file.'])
        disp('This will only run one time.')
        gshhs(gshhs_path, 'createindex');
    end
    data = gshhs(gshhs_path, ylims, xlims);



    box = [xlims(1) ylims(1);
        xlims(2) ylims(1);
        xlims(2) ylims(2);
        xlims(1) ylims(2);
        xlims(1) ylims(1)];
    coast0 = [[data(:).Lon]' [data(:).Lat]'];


    % % Rotate
    % [box(:,1), box(:,2)] = rotate_theta(box(:,1), box(:,2), -fgrid.rotate);
    % [coast0(:,1), coast0(:,2)] = rotate_theta(coast0(:,1), coast0(:,2), -fgrid.rotate);

    poly_box = polyshape(box, 'KeepCollinearPoints', true);
    poly_coast0 = polyshape(coast0, 'KeepCollinearPoints', true);

    Data = intersect(poly_box, poly_coast0);

end


h = plot(Data);
set(h, 'LineStyle', 'none')
set(h, 'FaceColor', patch_color)
set(h, 'FaceAlpha', 1)

if (~isempty(varargin))
    set(h, varargin{:});
end
