%==========================================================================
% Do PCA to 2-d vectors 
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
function [u, v, variance, theta] = calc_pca(u0, v0)


% clear, clc, close all
% 
% % Generate a test dataset
% rng(0)
% data(:,1) = randn(30,1);
% data(:,2) = 3.4 + 1.2 * data(:,1);
% data(:,2) = data(:,2) + 0.2*randn(size(data(:,1)));
% data = sortrows(data,1);
% data = [data; nan nan];
% u0 = data(:,1);
% v0 = data(:,2);
% % 
dims = size(u0);
k = find(~isnan(u0+v0));
u = u0(k);
u = u(:);
v = v0(k);
v = v(:);

% Step 1
% Remove the mean
% umean = mean(u);
% vmean = mean(v);
% u = u - umean;
% v = v - vmean;
data = [u v];

% Step 2
% Calculate the covariance matrix
C = cov(data);

% Step 3 
% Calculate the eigenvalues 
[V, D] = eig(C);


% Step 4
% Calculating the data set in the new coordinate system.
newdata = V' * data';
newdata = newdata';
variance = D / sum(D(:));
if D(2,2) > D(1,1)
    newdata = fliplr(newdata);
    theta = atan2d(V(2,2), V(1,2));
    variance = variance([4 1]);
else
    theta = atan2d(V(2,1), V(1,1));
end



u = nan(dims);
v = nan(dims);
u(k) = newdata(:,1);
v(k) = newdata(:,2);
