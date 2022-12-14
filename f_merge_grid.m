%==========================================================================
% 
%
% input  : 
% 
% output : 
%
% Siqi Li, SMAST
% yyyy-mm-dd
%
% Updates:
% 2021-08-30  Siqi Li  Considered h 
%
%==========================================================================
function fgrid2 = f_merge_grid(varargin)


x = [];
y = [];
nv = [];
h = [];

for i = 1 : nargin
    
    x1 = varargin{i}.x;
    y1 = varargin{i}.y;
    nv1 = varargin{i}.nv;
    if isfield(varargin{i}, 'h')
        h1 = varargin{i}.h;
    end
    
    m0 = length(x);
    
    x = [x;x1];
    y = [y;y1];
    nv = [nv; nv1 + m0];
    if isfield(varargin{i}, 'h')
        h = [h;h1];
    end
    
end

if isfield(varargin{i}, 'h')
    fgrid2 = f_load_grid(x, y, nv, h);
else
    fgrid2 = f_load_grid(x, y, nv);
end

fgrid2 = f_check_grid(fgrid2);