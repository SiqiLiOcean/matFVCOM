%==========================================================================
% Replace part of the SMS 2dm input file (ASCII)
%
% input  : fin    --- original 2dm path and name
%          fout   --- output 2dm path and name
%          
%
% 2dm file format:
% MESH2D
% E3T      1      6      1      7      1
% E3T      2      6      2      1      1
% ...
% ND      1 4.40624190e+005 3.21572150e+005 1.08688152e+000
% ND      2 4.40624490e+005 3.21535740e+005 8.22981596e-001
% ...
%
% Siqi Li, SMAST
% 2020-02-27
%==========================================================================
function replace_2dm(fin, fout, varargin)

%-----------------------------------------------
% Read the data to find the line #
%-----------------------------------------------

fid1 = fopen(fin);

data0 = textscan(fid1, '%s', 'Delimiter', '\n');
data0 = data0{1};

k_E3T = find(contains(data0,'E3T '));
k_ND = find(contains(data0,'ND '));
k_end = length(data0);

node = k_ND(end) - k_ND(1) + 1;
nele = k_E3T(end) - k_E3T(1) + 1;

fclose(fid1);

[x0, y0, nv0, h0] = read_2dm(fin);

%-----------------------------------------------
% Read the new data
%-----------------------------------------------

i = 1;
while i<length(varargin)
    
    switch varargin{i}
        case 'nv'
            nv0 = varargin{i+1};
        case {'lon', 'x'}
            x0 = varargin{i+1};
        case {'lat', 'y'}
            y0 = varargin{i+1};
        case 'h'
            h0 = varargin{i+1};
        case default
            error('Unknown varaible name.')
    end
    
    i = i + 2;
end

%-----------------------------------------------
% Write out the new file
%-----------------------------------------------
fid2 = fopen(fout, 'w');

% Before the nv
for i = 1 : k_E3T(1)-1
    fprintf(fid2, '%s\n', data0{i});
end
% nv
for i = 1 : size(nv0,1)
    fprintf(fid2, '%s%10d%10d%10d%10d%10d\n', 'E3T', i, nv0(i,:), 1);
end
% xy
for i = 1 : length(x0)
    fprintf(fid2,'%s%10d %15.8e %15.8e %15.8e\n','ND',i,x0(i),y0(i),h0(i));
end
% After the xy
for i = k_ND(end)+1 : k_end
    fprintf(fid2, '%s\n', data0{i});
end

fclose(fid2);    

