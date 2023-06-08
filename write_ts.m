%==========================================================================
% Write FVCOM TS DA input data
%
% input  :
%   sta  --- observation cell
%   fxy  --- TS DA xy file
%   fdat --- TS DA dat file
% 
% output :
%
% Siqi Li, SMAST
% 2021-12-02
%
% Updates:
% 2023-06-08  Siqi Li  Added the ideal time option.
%==========================================================================
function write_ts(sta, fxy, fdat, varargin)

varargin = read_varargin2(varargin, {'Ideal'});

missing_value = -99.90;

out_cell = isfield(sta, 'cell');
out_source = isfield(sta, 'source');

% MJD
mjd = datenum(1858, 11, 17, 0, 0, 0);
if ~isempty(Ideal)
    mjd = 0;
end

% --------------Write xy file---------------
disp('Write xy file')
fid1 = fopen(fxy, 'w');

fprintf(fid1, '%10d\n', length(sta));
    
for i = 1 : length(sta)
    
%     if (mod(i, 10) == 0)
%         disp([num2str(i, '%5.5d') ' / ' num2str(nsta, '%5.5d')])
%     end
    
    fprintf(fid1, '%6d %16.6f %16.6f %10.2f %10d %5.1f', ...
                   i, sta(i).x, sta(i).y, sta(i).h, length(sta(i).depth), 0.0);
    
    if out_cell
        fprintf(fid1, '%12d', sta(i).cell);
    end
    if out_source
        fprintf(fid1, '%8d', sta(i).source);
    end
    fprintf(fid1, '\n');
    
    for iz = 1 : length(sta(i).depth)
        fprintf(fid1, '%10.2f\n', sta(i).depth(iz));
    end
    
end

fclose(fid1);


% --------------Write dat file---------------
disp('Write dat file')
fid2 = fopen(fdat, 'w');
    
for i = 1 : length(sta)
    
    fprintf(fid2, '%10d %10d\n', i, length(sta(i).time));
    
    T = sta(i).T;
    T(isnan(T)) = missing_value;
    S = sta(i).S;
    S(isnan(S)) = missing_value;
    
    for it = 1 : length(sta(i).time)
        fprintf(fid2, '%14.6f', sta(i).time(it)-mjd);
                
        for iz = 1 : length(sta(i).depth)
            fprintf(fid2, '%9.2f %9.2f', T(iz,it), S(iz,it));
        end
        
        fprintf(fid2, '\n');
    end
    
end

fclose(fid2);


end