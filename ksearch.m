%==========================================================================
% matFVCOM package
%   Find k-nearest neighbors using input data 
%   This is an alternative function for knnsearch in 'Statistics and 
%   Machine Learning Toolbox'. When called, this function will use
%     --- 'knnsearch', if Statistics and Machine Learning Toolbox is
%         installed
%     --- an alternative loop (slow but with the same results of knnsearch)
%
% input  :
%   X  --- 2d input data, in size of (n,2)
%   Y  --- 2d query points, in size of (n0,2)
%   *K --- number of neareast neighbors {1}
% 
% output :
%   Idx --- ID of nearest points, in size of (n0,K)
%   D   --- distances between query points and neastest points, in size of 
%           (n0,K)
% 
% Siqi Li, SMAST
% 2023-03-21
%
% Updates:
%
%==========================================================================
function [Idx, D] = ksearch(X, Y, varargin)

varargin = read_varargin(varargin, {'K'}, {1});

if exist('knnsearch', 'file')
    [Idx, D] = knnsearch(X, Y, 'K', K);
else
    src_x = X(:,1);
    src_y = X(:,2);
    x0 = Y(:,1);
    y0 = Y(:,2);
    n0 = length(x0);
    
    Idx = nan(n0, K);
    D = nan(n0, K);
    for i = 1 : n0
        d = sqrt((src_x-x0(i)).^2 + (src_y-y0(i)).^2);
        [~, id] = sort(d, 'ascend');
        Idx(i,1:K) = id(1:K);
        D(i,1:K) = d(id(1:K));
    end
end


end