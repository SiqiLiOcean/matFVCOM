%==========================================================================
% Read FVCOM Current DA input data
%
% input  :
%   fxy  --- Current DA xy file
%   fdat --- Current DA dat file
% 
% output :
%   sta
%
% Siqi Li, SMAST
% 2021-10-08
%
% Updates:
%
%==========================================================================
function  sta = read_current(fxy, fdat)

% clc
% clear
% fxy = 'gom5_current.xy';
% fdat = 'gom5_current.dat';


%------Read xy file--------------------------------------
fid = fopen(fxy);
% Read station #
nsta = str2double(fgetl(fid));
nz = nan(1,nsta);
% Read observation
for i = 1 : nsta
    line = fgetl(fid);
%     data = str2num(line);
    data = textscan(line, '%s');
    data = data{1};
    nz(i) = str2num(data{5});
    
    sta(i,1).x = str2num(data{2});
    sta(i,1).y = str2num(data{3});
    sta(i,1).h = str2num(data{4});
    sta(i,1).nz = nz(i);
    
    if length(data)>6
        sta(i,1).source = data{7};
    end

%     if length(data) >= 7
%         sta(i,1).cell = data(7);
%     end
%     
%     if length(data) >= 8
%         sta(i,1).source = data(8);
%     end
    
    depth = nan(nz(i),1);
    for iz = 1 : nz(i)
        depth(iz) = str2double(fgetl(fid));
    end
    
    sta(i,1).depth = depth;
end
fclose(fid);

%------Read dat file-------------------------------------
nt = nan(1,nsta);
fid = fopen(fdat);
for i = 1 : nsta
    data = str2num(fgetl(fid));
    nt(i) = data(2);
    
    sta(i,1).nt = nt(i);
    
    time = nan(1,nt(i));    
    U = nan(nz(i), nt(i));
    V = nan(nz(i), nt(i));
    for it = 1 : nt(i)
        data = str2num(fgetl(fid));
        time(it) = data(1);
        U(:,it) = data(2:2:end);
        V(:,it) = data(3:2:end);
    end
    
    [U, V] = check_missing(U, V);
    
    sta(i,1).time = time + datenum(1858, 11, 17, 0, 0, 0);
    sta(i,1).U = U / 100;
    sta(i,1).V = V / 100;
end   
fclose(fid);

end



function [u, v]=check_missing(u0, v0)
    s = abs(u0) + abs(v0);
    k = find(s<1e-4);
    u = u0;
    v = v0;
    u(k) = nan;
    v(k) = nan;
end