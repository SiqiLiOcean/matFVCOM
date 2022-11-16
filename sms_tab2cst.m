%==========================================================================
%
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% 2022-08-26
%
% Updates:
%
%==========================================================================
function sms_tab2cst(fin, fout)


fid = fopen(fin);
data = textscan(fid, '%f %f', 'Delimiter', ' ', 'headerlines', 1);
fclose(fid);
x = data{1};
y = data{2};

write_cst(fout, x, y)