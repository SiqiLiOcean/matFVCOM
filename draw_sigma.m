%==========================================================================
%
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% 2022-12-27
%
% Updates:
%
%==========================================================================
function draw_sigma(sigma, varargin)

varargin = read_varargin(varargin, {'hmin'}, {10});
if isfield(sigma, 'min_const_depth')
    varargin = read_varargin(varargin, {'hmax'}, {sigma.min_const_depth*2});
else
    varargin = read_varargin(varargin, {'hmax'}, {500});
end

% Generate the topography
for i=1:150
    h(i)=1/(i-200)+2/50;
end
for i=151:300
    h(i)=1/(i-100);
end
h=(h-h(1));
h=-h/h(end)*(hmax-hmin)-hmin;


[~, ~, ~, deplev] = calc_sigma(-h, sigma);
x = interp1(h, 1:300, -sigma.min_const_depth);

% Plot
hold on
if isfield(sigma, 'min_const_depth')
    plot([x x],[0 -225],'k--')
end
patch([1:300 1 1],[h -hmax -hmin],[222,184,135]/255)
if isfield(sigma, 'min_const_depth')
    plot([0 145],[-sigma.min_const_depth -sigma.min_const_depth],'k--')
end
plot(-deplev,'k-', 'LineWidth', .6)
plot(1:300,h, 'r-')
set(gca,'xlim',[1 300])
set(gca,'ylim',[-hmax 0])
set(gca,'xticklabel','')
ylabel('Depth (m)')
mf_ytick_minus(gca)


