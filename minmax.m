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

out = [varmin varmax];