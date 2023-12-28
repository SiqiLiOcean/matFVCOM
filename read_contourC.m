function [levels, Cout] = read_contourC(C, varargin)


varargin = read_varargin(varargin, {'MinNum'}, {40}); % At least it should be a triangle.
varargin = read_varargin2(varargin, {'Closed'});

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