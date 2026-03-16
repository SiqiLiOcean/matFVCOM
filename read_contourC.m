function [levels, Cout] = read_contourC(C, varargin)


varargin = read_varargin(varargin, {'MinNum'}, {40}); % At least it should be a triangle.
varargin = read_varargin2(varargin, {'Closed'});
varargin = read_varargin(varargin, {'Boundary'}, {{}});


i = 0;
k = 0;

levels = [];
Cout = [];
while i < size(C,2)
    if C(2,i+1)>=MinNum
        k = k + 1;
        
        i = i + 1;
        levels(k).level = C(1,i);
        n = C(2,i);
        
        i = i + 1;

        if ~isempty(Closed) && (C(1,i)~=C(1,i+n-1) || C(2,i)~=C(i+n-1))
            levels(k).x = [C(1,i:i+n-1) C(1,i) nan];
            levels(k).y = [C(2,i:i+n-1) C(2,i) nan];
        
            levels(k).n = n + 2;
        
            Cout = [Cout C(1:2, i-1:i+n-1) C(1:2,i)];
        else
            levels(k).x = [C(1,i:i+n-1) nan];
            levels(k).y = [C(2,i:i+n-1) nan];
        
            levels(k).n = n + 1;
        
            Cout = [Cout C(1:2, i-1:i+n-1)];
        end
        
        i = i + n - 1;
        
        
    else
        i = i + 1 + C(2,i+1);
    end
    
end

if ~isempty(Boundary)
    levels = set_levels_boundary(levels, Boundary{1}, Boundary{2});
end

end

function levels2 = set_levels_boundary(levels1, px, py)


n1 = length(levels1);
i2 = 0;
levels2 = [];
for i1 = 1 : n1

    lx = levels1(i1).x;
    ly = levels1(i1).y;

    in = inpolygon(lx, ly, px, py);

    % Detect start and end of each sequence of 1s
    d = diff([0 in 0]);           % Pad to detect edges
    start_idx = find(d == 1);
    end_idx = find(d == -1) - 1;

    % Get index groups
    id_groups = cell(1, numel(start_idx));
    for k = 1:numel(start_idx)
        id_groups{k} = start_idx(k):end_idx(k);

        i2 = i2 + 1;
        levels2(i2).level = levels1(i1).level;
        levels2(i2).x = [levels1(i1).x(id_groups{k}) nan];
        levels2(i2).y = [levels1(i1).y(id_groups{k}) nan];
        levels2(i2).n = length(levels2(i2).x);
    end

end

end