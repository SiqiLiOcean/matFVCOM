%==========================================================================
% Write the SMS 2dm input file (ASCII)
%
% input  : output
%          x  (x coordinate)
%          y  (y coordinate)
%          nv (triangle matrix)
%          h  (depth,m), optional
%
% 2dm file format:
% MESH2D
% E3T      1      6      1      7      1
% E3T      2      6      2      1      1
% ...
% ND      1 4.40624190e+005 3.21572150e+005 1.08688152e+000
% ND      2 4.40624490e+005 3.21535740e+005 8.22981596e-001
% ...
% NS  160527 160528 160347 160162 159985 159814 159641 159459 159274 159087
% NS  159086 159272 -159455
% ...
%
% Siqi Li, SMAST
% 2020-04-14
%
% Updates
% 2022-04-15  Siqi Li  Add nodestrings
%==========================================================================
function write_2dm(foutput, x, y, nv, h, ns, tail)


% % Make sure the direction of cell nodes are counter clockwise
% tf = f_calc_grid_direction(x, y, nv);
% k = find(tf>0);
% if ~isempty(k)
%     nv0 = nv;
%     nv(k,2) = nv0(k,3);
%     nv(k,3) = nv0(k,2);
%     disp(' ')
%     disp('------------------------------------------------')
%     disp([num2str(length(k)) ' of ' num2str(size(nv,1)) ' cells are in ' ...
%           'wrong direction (clockwise).'])
%     disp('Have changed them to counter clockwise direction!')
%     disp('------------------------------------------------')
%     disp(' ')
% end


% if_depth=0;
% k=1;
% while k<=length(varargin) 
%     switch lower(varargin{k}(1:5))
%         case 'depth'
%             h=varargin{k+1};
%             if_depth=1;
%     end
%     k=k+2;
% end


node=length(x);
nele=size(nv,1);

% if ~isempty(varargin)
%     h = varargin{1};
% else
%     h = zeros(node,1); 
% end
if exist('h', 'var') 
    if isnan(h)
        h = zeros(node,1); 
    end
else
    h = zeros(node,1); 
end

if exist('ns', 'var')

else
    ns = {};
end

if exist('tail', 'var')

else
    tail = {};
end

fid=fopen(foutput,'w');
fprintf(fid,'%s\n','MESH2D');
% E3T
for j=1:nele
    fprintf(fid,'%s%10d%10d%10d%10d%10d\n','E3T',j,nv(j,:),1);
end
% ND
for i=1:node
    fprintf(fid,'%s%10d %15.8e %15.8e %15.8e\n','ND',i,x(i),y(i),h(i));
end
% NS
nmax = 10;
for i = 1 : length(ns)
    data = ns{i};
    data(end) = -data(end);
    ntotal = length(data);
    k1 = 1;
    for j = 1 : ceil(ntotal/nmax)
        n = min(ntotal-(j-1)*nmax, nmax);
        k2 = k1 + n - 1;
        format = ['%s' repmat('%8d', 1, n), '\n'];
        fprintf(fid, format, 'NS  ', data(k1:k2));
        k1 = k2 + 1;
    end  
end
% Tail
for i = 1 : length(tail)
    fprintf(fid, '%s\n', tail{i});
end

% if if_depth
%     for i=1:node
%         fprintf(fid,'%s%10d %15.8e %15.8e %15.8e\n','ND',i,x(i),y(i),h(i));
%     end
% else
%     for i=1:node
%         fprintf(fid,'%s%10d %15.8e %15.8e\n','ND',i,x(i),y(i));
%     end
% end

fclose(fid);

end
