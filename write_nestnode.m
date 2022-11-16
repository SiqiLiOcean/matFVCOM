%==========================================================================
% Write FVCOM nestnode file 
%
% input  :
%   fnestnode --- nestnode file path and name
%   nestnode  --- nesting node ids
% output :
%   
%
%   * The 3rd column of nestnode file is not used in FVCOM.
%
% Siqi Li, SMAST
% 2022-10-25
%
% Updates:
%
%==========================================================================
function write_nestnode(fnestnode, nestnode)

n = length(nestnode);
fid = fopen(fnestnode, 'w');
fprintf(fid, '%s %d\n', 'Node_Nest Number =', n);
for i = 1 : n
    fprintf(fid, '%12d %12d %12d\n', i, nestnode(i), 1);
end
fclose(fid);