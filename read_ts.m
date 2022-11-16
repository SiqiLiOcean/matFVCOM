%==========================================================================
% Read FVCOM TS DA input data
%
% input  :
%   fxy  --- TS DA xy file
%   fdat --- TS DA dat file
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
function  sta = read_ts(fxy, fdat)

% clc
% clear
% fxy = 'gom5_ts.xy';
% fdat = 'gom5_ts.dat';


%------Read xy file--------------------------------------
fid = fopen(fxy);
% Read station #
nsta = str2double(fgetl(fid));
nz = nan(1,nsta);
% Read observation
for i = 1 : nsta
    data = str2num(fgetl(fid));
    
    nz(i) = data(5);
    
    sta(i,1).x = data(2);
    sta(i,1).y = data(3);
    sta(i,1).h = data(4);
    sta(i,1).nz = nz(i);
    
    if length(data) >= 7
        sta(i,1).cell = data(7);
    end
    
    if length(data) >= 8
        sta(i,1).source = data(8);
    end
    
    depth = nan(1,nz(i));
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
    T = nan(nz(i), nt(i));
    S = nan(nz(i), nt(i));
    for it = 1 : nt(i)
        data = str2num(fgetl(fid));
        time(it) = data(1);
        T(:,it) = data(2:2:end);
        S(:,it) = data(3:2:end);
    end
    
    T=check_missing(T, -5, 50);
    S=check_missing(S, 0, 50);
    
    sta(i,1).time = time + datenum(1858, 11, 17, 0, 0, 0);
    sta(i,1).T = T;
    sta(i,1).S = S;
end   
fclose(fid);

end



function z=check_missing(z0,zmin,zmax)
    id=find(z0<zmin | z0>zmax);
    z=z0;
    z(id)=nan;
end