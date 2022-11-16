%==========================================================================
% Read FVCOM nestnode file 
%
% input  :
%   fnestnode --- nestnode file path and name
% output :
%   nestnode  --- nesting node ids
%
%   * The 3rd column of nestnode file is not used in FVCOM.
% Siqi Li, SMAST
% 2022-10-25
%
% Updates:
%
%==========================================================================
function nestnode = read_nestnode(fnestnode)

fid = fopen(fnestnode);
data = textscan(fid, '%d %d %d\n', 'headerlines', 1);
nestnode = data{2};
fclose(fid);