%==========================================================================
% Read FVCOM Current DA input data
%
% input  :
%   sta  --- observation cell
%           --- x
%           --- y
%           --- h
%           --- nz
%           --- z
%           --- nt
%           --- time
%           --- u
%           --- v
%   fxy  --- Current DA xy file
%   fdat --- Current DA dat file
% 
% output :
%
% Siqi Li, SMAST
% 2021-10-08
%
% Updates:
%
%==========================================================================
function  write_current(sta, fxy, fdat)

missing_value = 0.0;

out_cell = isfield(sta, 'cell');
out_source = isfield(sta, 'source');

% MJD
mjd = datenum(1858, 11, 17, 0, 0, 0);

% --------------Write xy file---------------
disp('Write xy file')
fid1 = fopen(fxy, 'w');

fprintf(fid1, '%10d\n', length(sta));
    
for i = 1 : length(sta)
    
%     if (mod(i, 10) == 0)
%         disp([num2str(i, '%5.5d') ' / ' num2str(nsta, '%5.5d')])
%     end
    
    fprintf(fid1, '%6d %16.6f %16.6f %10.2f %10d %5.1f', ...
                   i, sta(i).x, sta(i).y, sta(i).h, sta(i).nz, 0.0);
    
    if out_cell
        fprintf(fid1, '%12d', sta(i).cell);
    end
    if out_source
        fprintf(fid1, '%8s', sta(i).source);
    end
    fprintf(fid1, '\n');
    
    for iz = 1 : sta(i).nz
        fprintf(fid1, '%10.2f\n', sta(i).z(iz));
    end
    
end

fclose(fid1);


% --------------Write dat file---------------
disp('Write dat file')
fid2 = fopen(fdat, 'w');
    
for i = 1 : length(sta)
    
    fprintf(fid2, '%10d %10d\n', i, sta(i).nt);
    
    u = sta(i).u;
    u(isnan(u)) = missing_value;
    v = sta(i).v;
    v(isnan(v)) = missing_value;
    
    for it = 1 : sta(i).nt
        fprintf(fid2, '%14.6f', sta(i).time(it)-mjd);
                
        for iz = 1 : sta(i).nz
            fprintf(fid2, '%9.2f %9.2f', u(iz,it), v(iz,it));
        end
        
        fprintf(fid2, '\n');
    end
    
end

fclose(fid2);