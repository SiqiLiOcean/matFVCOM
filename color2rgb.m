function color = color2rgb(color)

switch class(color)
    case 'char'
        RGB = COLOR2RGB(color);
        color = RGB2ABGR(255, RGB);
    case 'double'
        color = RGB2ABGR(255, color);
    otherwise
        error('Unknown color')
end

end


function ARGB = RGB2ABGR(alpha, RGB)

    if max(alpha) <= 1
        alpha = alpha * 255;
    end
    if max(RGB(:)) <= 1
        RGB = RGB * 255;
    end
    
    ARGB = [dec2hex(alpha,2) dec2hex(RGB(3),2) dec2hex(RGB(2),2) dec2hex(RGB(1),2)];
    
end

function RGB = COLOR2RGB(COLOR)
    
    switch COLOR
        case {'red', 'r'}
            RGB = [255 0 0];
        case {'green', 'g'}
            RGB = [0 255 0];
        case {'blue', 'b'}
            RGB = [0 0 255];
        case {'cyan', 'c'}
            RGB = [0 255 255];
        case {'magenta', 'm'}
            RGB = [255 0 255];
        case {'yellow', 'y'}
            RGB = [255 255 0];
        case {'black', 'k'}
            RGB = [0 0 0];
        case {'white', 'w'}
            RGB = [255 255 255];
        otherwise
            error(['Unknown color code: ' COLOR])
    end
    
end