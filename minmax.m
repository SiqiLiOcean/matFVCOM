function out = minmax(var)

varmin = min(var(:));
varmax = max(var(:));


% n = size(var);
% 
% nd = length(n);
% 
% varmin = var;
% varmax = var;
% for i = 1 : nd
%     
%     varmin = min(varmin);
%     varmax = max(varmax);
%     
% end

k = sum(isnan(var(:)));
if k>0
    disp(['There are ' num2str(k) ' nan.'])
end

out = [varmin varmax];