function [x, y] = get_coastline_gshhs(xlims, ylims, Resolution)



PATH = set_path;

Resolution = lower(Resolution);
if sum(ismember('clihf', Resolution)) ~= 1
    error('Unknown resolution. Options: c, l, i, h, f');
end


if contains(computer, 'WIN')
    gshhs_path = [PATH.gshhs '\gshhs_' Resolution '.b'];
    gshhs_index = [PATH.gshhs '\gshhs_' Resolution '.i'];
else
    gshhs_path = [PATH.gshhs '/gshhs_' Resolution '.b'];
    gshhs_index = [PATH.gshhs '/gshhs_' Resolution '.i'];
end




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

poly_box = polyshape(box, 'KeepCollinearPoints', true);
poly_coast0 = polyshape(coast0, 'KeepCollinearPoints', true);

Data = intersect(poly_box, poly_coast0);

x0 = [Data.Vertices(:,1); NaN];
y0 = [Data.Vertices(:,2); NaN];

j2 = -1;
nan_index = find(isnan(x0));
x = [];
y = [];
for i = 1 : length(nan_index)
    j1 = j2 + 2;
    j2 = nan_index(i) - 1;
    x = [x; x0([j1:j2 j1]); NaN];
    y = [y; y0([j1:j2 j1]); NaN];
end
