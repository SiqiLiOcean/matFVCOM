%==========================================================================
% Project vector B onto A
%
% input  :
%   A --- Projecting direction vector
%   B --- Vector to be projected
% 
% output :
%   projB --- length of projected B
%
% Siqi Li, SMAST
% 2022-07-27
%
% Updates:
%
%==========================================================================
function projB = calc_proj_vector(A, B)

% A = [-7,0];
% B = [-1,-1];

lenA = norm(A);
lenB = norm(B);

cosTheta = dot(A, B) / lenA / lenB;

projB = lenA * cosTheta;

