%==========================================================================
% Merge multiple fiels into one 
%
% input  :
%   f      --- destination grid
%   fin    --- cell of the source grids, the last one should be for the
%              largest domain
%   bdy_x  --- cell of boundary x
%   bdy_y  --- cell of boundary y
%   var_in --- cell for variables of different grids
% 
% output :
%   var    --- interpolated results
%   index  --- results from f_nesting_merge1
%
% Siqi Li, SMAST
% yyyy-mm-dd
%
% Updates:
%
%==========================================================================
function [var, index] = f_nesting_merge(f, fin, bdy_x, bdy_y, var_in) 



index = f_nesting_merge1(f, fin, bdy_x, bdy_y);

var = f_nesting_merge2(index, var_in) ;

