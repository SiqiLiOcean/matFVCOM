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
%
%==========================================================================
function convert_fig2avi(fin, fout, varargin)


varargin = read_varargin(varargin, {'FrameRate'}, {3});


files = dir(fin);

n = length(files);

writerObj = VideoWriter(fout);
writerObj.FrameRate = FrameRate;
open(writerObj);
for K = 1 : n
  filename = [files(K).folder '/' files(K).name];
  thisimage = imread(filename);
  writeVideo(writerObj, thisimage);
end
close(writerObj);
