%==========================================================================
% Read the SMS 2dm input file (ASCII)
%
% input  : 2dm path and name
% output : x  (x coordinate)
%          y  (y coordinate)
%          nv (triangle matrix)
%          h  (depth)
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
% 2020-02-27
%
% Updates:
% 2022-09-06  Siqi Li  2dm file may contain no NS lines.
% 2021-04-16  Siqi Li  The output order is changed to [x,y,nv,h], since not
%                      all 2dm have the depth data.
% 2021-06-15  Siqi Li  Read the index of nodes.
% 2021-04-15  Siqi Li  Read nodestrings
%==========================================================================
function [x, y,nv, h, ns, tail, id]=read_2dm(fin)


fid=fopen(fin);

% Read the data to find the line #
data = textscan(fid, '%s', 'Delimiter','\n');

k_E3T = find(contains(data{1},'E3T '));
k_ND = find(contains(data{1},'ND '));
k_NS = find(contains(data{1}, 'NS '));

% Read the data to get the nv
frewind(fid);
data = textscan(fid, '%s %d %d %d %d %d', k_E3T(end)-k_E3T(1)+1, ...
                     'headerlines', k_E3T(1)-1);
% idc = data{2};                 
nv = [data{3} data{4} data{5}];

% Read the data to get the x, y, h
frewind(fid);
data = textscan(fid, '%s %d %f %f %f %f', k_ND(end)-k_ND(1)+1, ...
                     'headerlines', k_ND(1)-1);
id = data{2};                 
x = data{3};
y = data{4};
h = data{5};

% Read the data to get the nodestrings
if isempty(k_NS)
    ns = {};
else
    frewind(fid);
    data = textscan(fid, '%s', k_NS(end)-k_NS(1)+1, ...
                         'headerlines', k_NS(1)-1, ...
                         'Delimiter', '\n');
    data = data{1};
    ns_str = [];
    for i = 1 : length(data)
        ns_str = [ns_str data{i}(4:end)];
    end
    ns_num = str2num(ns_str);
    ns_end = find(ns_num<0);
    ns_start = [1 ns_end(1:end-1)+1];
    for i = 1 : length(ns_start)
        ns{i,1} = ns_num(ns_start(i):ns_end(i));
        ns{i,1}(end) = -ns{i}(end);
    end
end

% Read the lines after E3T, ND, NS
if ~isempty(k_NS)
    frewind(fid);
    data = textscan(fid, '%s', 'headerlines', k_NS(end));
    tail = data{1};
else
    tail = [];
end

fclose(fid);

disp(' ')
disp('------------------------------------------------')
disp(['2dm file: ' fin])
disp(['Node #: ' num2str(length(x))])
disp(['Cell #: ' num2str(size(nv,1))])
disp(['x range: ' num2str(min(x)) ' ~ ' num2str(max(x))])
disp(['y range: ' num2str(min(y)) ' ~ ' num2str(max(y))])
disp(['h range: ' num2str(min(h)) ' ~ ' num2str(max(h))])
disp('------------------------------------------------')
disp(' ')


% fid=fopen(finput);
% iline = 0;
% % initial
% x=[];
% y=[];
% h=[];
% nv=[];
% while (~feof(fid))
%     line=fgetl(fid);
%     iline = iline + 1;
%     line=strtrim(line);
%     
%     if (mod(iline, 10000)==0)
%         disp(['Reading ' num2str(iline)])
%     end
%     
%     switch line(1:3)  
%         case('E3T')  % The nv line starts with the 'E3T'
%             data=textscan(line,'%s %d %d %d %d %d',1);
%             nv=[nv; cell2mat(data(3:5))];
%         case('ND ')  % The coordinates and depth start with 'ND'
%             data=textscan(line,'%s %d %f %f %f',1);
%             x=[x; cell2mat(data(3))];
%             y=[y; cell2mat(data(4))];
%             h=[h; cell2mat(data(5))];  
%     end    
% end
% fclose(fid);

end
