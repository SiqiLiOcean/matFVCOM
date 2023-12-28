%==========================================================================
% Draw 2d contour for angle (0-360) 
%
% input  : 
%   xx        --- grid x coordinate
%   yy        --- grid y coordinate
%   zz_360    --- grid angle ranging [0, 360]
%   zz_180    --- grid angle ranging [-180, 180]
%   LevelList --- isolines list
%
% output :
%
% Usage: 
%   contour_angle(xx, yy, zz_360, zz_180, LevelList);
%
% Siqi Li, SMAST
% 2020-07-16
%==========================================================================
function contour_angle(xx, yy, zz_360, zz_180, LevelList, varargin)

varargin = read_varargin(varargin, ...
            {'FontSize', 'LabelSpacing', 'Color'}, ...
            {        12,            200,     'k'});

% 1) draw isolines for (0 90)
theta = zz_180;
theta(theta>=90 | theta<=0) = nan;
vals = sind(theta);
list = LevelList;
list(list>=90 | list<=0) = [];
[C, h] = contour(xx, yy, vals, 'LevelList', sind(list), 'LabelFormat', @fun1, 'Color', Color);
% [~, C] = read_contourC(C, 'MinNum', MinNum);
clabel(C, h, 'fontsize',FontSize, ...
                'LabelSpacing', LabelSpacing, ...
                'Color', Color);

% 2) draw isolines for (90 180)
theta = zz_360;
theta(theta>=180 | theta<=90) = nan;
vals = sind(theta);
list = LevelList;
list(list>=180 | list<=90) = [];
[C, h] = contour(xx, yy, vals, 'LevelList', sind(list), 'LabelFormat', @fun2, 'Color', Color);
% [~, C] = read_contourC(C, 'MinNum', MinNum);
clabel(C, h, 'fontsize',FontSize, ...
                'LabelSpacing', LabelSpacing, ...
                'Color', Color);

% 3) draw isolines for (180 270]
theta = zz_360;
theta(theta>=270 | theta<=180) = nan;
vals = cosd(theta);
list = LevelList;
list(list>=270 | list<=180) = [];
[C, h] = contour(xx, yy, vals, 'LevelList', cosd(list), 'LabelFormat', @fun3, 'Color', Color);
% [~, C] = read_contourC(C, 'MinNum', MinNum);
clabel(C, h, 'fontsize',FontSize, ...
                'LabelSpacing', LabelSpacing, ...
                'Color', Color);

% 4) draw isolines for (270 360)
theta = zz_180;
theta(theta<=-90 | theta>=0) = nan;
vals = cosd(theta);
list = calc_lon_180(LevelList);
list(list<=-90 | list>=0) = [];
[C, h] = contour(xx, yy, vals, 'LevelList', cosd(list), 'LabelFormat', @fun3, 'Color', Color);
% [~, C] = read_contourC(C, 'MinNum', MinNum);
clabel(C, h, 'fontsize',FontSize, ...
                'LabelSpacing', LabelSpacing, ...
                'Color', Color);

% 5) draw isolines for 0
if  ismember(0, LevelList) || ismember(360, LevelList)
    theta = zz_180;
    theta(theta<-70 | theta>70) = nan;
    vals = sind(theta);
    [C, h] = contour(xx, yy, vals, 'LevelList', sind(0), 'LabelFormat', @fun1, 'Color', Color);
    % [~, C] = read_contourC(C, 'MinNum', MinNum);
    clabel(C, h, 'fontsize',FontSize, ...
                'LabelSpacing', LabelSpacing, ...
                'Color', Color);
end

% 6) draw isolines for 90
if  ismember(90, LevelList)
    theta = zz_360;
    theta(theta>=160 | theta<=20) = nan;
    vals = cosd(theta);
    [C, h] = contour(xx, yy, vals, 'LevelList', cosd(90), 'LabelFormat', @fun4, 'Color', Color);
    % [~, C] = read_contourC(C, 'MinNum', MinNum);
    clabel(C, h, 'fontsize',FontSize, ...
                'LabelSpacing', LabelSpacing, ...
                'Color', Color);
end

% 7) draw isolines for 180
if  ismember(180, LevelList)
    theta = zz_360;
    theta(theta<110 | theta>250) = nan;
    vals = sind(theta);
    [C, h] = contour(xx, yy, vals, 'LevelList', sind(180), 'LabelFormat', @fun2, 'Color', Color);
    % [~, C] = read_contourC(C, 'MinNum', MinNum);
    clabel(C, h, 'fontsize',FontSize, ...
                'LabelSpacing', LabelSpacing, ...
                'Color', Color);
end

% 8) draw isolines for 270
if  ismember(270, LevelList)
    theta = zz_360;
    theta(theta<200 | theta>340) = nan;
    vals = cosd(theta);
    [C, h] = contour(xx, yy, vals, 'LevelList', cosd(90), 'LabelFormat', @fun3, 'Color', Color);
    % [~, C] = read_contourC(C, 'MinNum', MinNum);
    clabel(C, h, 'fontsize',FontSize, ...
                'LabelSpacing', LabelSpacing, ...
                'Color', Color);
end

end



function labels = fun1(vals)
    labels = round(asind(vals));
end

function labels = fun2(vals)
    labels = 180 - round(asind(vals));
end

function labels = fun3(vals)
    labels = 360 - round(acosd(vals));
end

function labels = fun4(vals)
    labels = round(acosd(vals));
end