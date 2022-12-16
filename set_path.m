%==========================================================================
% Set the path for the matFVCOM package
%
% input  :
%   \
% output :
%   PATH
%
% Siqi Li, SMAST
% 2022-12-16
%
% Updates:
%
%==========================================================================
function PATH = set_path

% Type your GSHHS coastline data directory here
PATH.gshhs = 'D:\data';
% Type your ETOPO1 data path here
PATH.etopo1 = 'D:\data\ETOPO1_Bed_g_gmt4.grd';


if isempty(PATH.gshhs)
    
        PATH.gshhs = [fundir('set_path') 'data'];
end
if isempty(PATH.etopo1)
    if contains(computer, 'WIN')
        PATH.etopo1 = [fundir('set_path') 'data\ETOPO1_Bed_g_gmt4.grd'];
    else
        PATH.etopo1 = [fundir('set_path') 'data/ETOPO1_Bed_g_gmt4.grd'];
    end
end


end