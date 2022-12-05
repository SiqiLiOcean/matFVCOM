%==========================================================================
% Write out the coastline in cst format
% 
% Input  : --- fout, output cst file
%          --- cst_x, x of coastlines (different islands are seperated by nan)
%          --- cst_y, y of coastlines (different islands are seperated by nan)
%
% Output :
% 
% Usage  : write_cst(fout, cst_x, cst_y);
%
% v1.0
%
% Siqi Li
% 2021-04-14
%
% Updates:
%
%==========================================================================
function write_cst(fout, cst_x, cst_y)

cst_x = cst_x(:);
cst_y = cst_y(:);



% The cst_x and cst_y arrays should START and END with nan. 
% Different coastlines are saperated with nan.
if ~isnan(cst_x(end))
    cst_x = [cst_x; nan];
    cst_y = [cst_y; nan];
end
if ~isnan(cst_x(1))
    cst_x = [nan; cst_x];
    cst_y = [nan; cst_y];
end

k = find(isnan(cst_x));
n = length(k) - 1;


% coast=[main_out ;island_out(2:end,:)];
% npart=sum(isnan(coast(:,1)))-1;
% tmp=find(isnan(coast(:,1)));
% a1=tmp(1:end-1);
% a2=tmp(2:end);
% part_k=[a1+1 a2-1];

% Wrtie into cst file.
fid=fopen(fout,'w');

fprintf(fid,'%s\n','COAST');
fprintf(fid,'%d %f\n', n, 0.0);

for i = 1 : n
    
    % Start and end index of this coastline
    j1 = k(i) + 1;
    j2 = k(i+1) - 1;
    
    % Differences of x and y between the first and last points.
    dx = abs(cst_x(j1)-cst_x(j2));
    dy = abs(cst_y(j1)-cst_y(j2));
    
    % Check if the coastline is closed.
    if dx<1e-6 && dy<1e-6
        is_close = 1;
    else
        is_close = 0;
    end
    
    fprintf(fid, '%d %d\n', j2-j1+1, is_close);

    for j = j1 : j2
        fprintf(fid, '%14.6f %14.6f %4.1f\n', cst_x(j), cst_y(j), 0.0);
    end
    
end

% for i=1:npart
%     if(coast(a1(i),:)==coast(a2(i),:))
%         is_close=1;
%     else
%         is_close=0;
%     end
%     fprintf(fid,'%d %d\n',a2(i)-a1(i)-1,is_close);
%     for j=a1(i)+1:a2(i)-1
%         fprintf(fid,'%14.6f %14.6f %4.1f\n',coast(j,1),coast(j,2),0.0);
%     end
% end
fclose(fid);
