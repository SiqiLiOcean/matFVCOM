%==========================================================================
% matFVCOM package
%   Create the boundary of all CUDEM data
%
% input  :
%   demdir
%
% output :
%   poly --- CUDEM polygon
%
% Siqi Li, SMAST
% 2023-07-24
%
% Updates:
%
%==========================================================================
function [bdy_x, bdy_y] = cudem_boundary(demdir, varargin)

bdy_x = [];
bdy_y = [];

files = dir([demdir '/*.tif']);

for i = 1 : length(files)
    
    fin = [files(i).folder '/' files(i).name];
    
    disp([num2str(i, '%3.3d') '/' num2str(length(files), '%3.3d') ' : ' files(i).name])

    % Read xlims and ylims
    [xlims, ylims] = read_tiff_lims(fin);
    
    bdy_x = [bdy_x xlims([1 2 2 1])];
    bdy_y = [bdy_y ylims([1 1 2 2])];
    if i < length(files)
        bdy_x = [bdy_x nan];
        bdy_y = [bdy_y nan];
    end
    
end


