%==========================================================================
%
% input  :
%
% output :
%
% Siqi Li, SMAST
% yyyy-mm-dd
%
% Updates:
%
%==========================================================================
function [h, poly_coast] = w_2d_coast(wgrid, varargin)


varargin = read_varargin2(varargin, {'New'});
varargin = read_varargin(varargin, ...
    {'xlims', 'ylims'}, ...
    {[min(wgrid.x) max(wgrid.x)], [min(wgrid.y) max(wgrid.y)], 'xy'});
varargin = read_varargin(varargin, {'Resolution'}, {'l'});


patch_color = [222,184,135]/255;   % tan

if isempty(New) && isfield(wgrid, 'poly_coast')
    poly_coast = wgrid.poly_coast;
else
    
    

    
    
    Resolution = lower(Resolution);
    if sum(ismember('clih', Resolution)) ~= 1
        error('Unknown resolution. Options: c, l, i, h, f');
    end
    
    
    
    xlim0 = get(gca, 'xlim');
    ylim0 = get(gca, 'ylim');
    
    if sum([xlim0 ylim0]==[0 1 0 1]) == 4
        
    else
            xlims = xlim0;
            ylims = ylim0;
    end
    
    % The gshhs file path
    
%     gshhs_path = [fundir('w_2d_coast') 'data\gshhs_' Resolution '.b'];
%     gshhs_index = [fundir('w_2d_coast') 'data\gshhs_' Resolution '.i'];
    if contains(computer, 'WIN')
        gshhs_path = [fundir('w_2d_coast') 'data\gshhs_' Resolution '.b'];
        gshhs_index = [fundir('w_2d_coast') 'data\gshhs_' Resolution '.i'];
    else
        gshhs_path = [fundir('w_2d_coast') 'data/gshhs_' Resolution '.b'];
        gshhs_index = [fundir('w_2d_coast') 'data/gshhs_' Resolution '.i'];
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
    
    poly_coast = intersect(poly_box, poly_coast0);
    
    wgrid.poly_coast = poly_coast;
    assignin('caller', inputname(1), wgrid);
    
end


h = plot(poly_coast);
set(h, 'Linewidth', 1.3)
set(h, 'LineStyle', 'none')
set(h, 'FaceColor', patch_color)
set(h, 'FaceAlpha', 1)

if (~isempty(varargin))
    set(h, varargin{:});
end
