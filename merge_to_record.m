%==========================================================================
%
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% 2021-09-28
%
% Updates:
%
%==========================================================================
function record = merge_to_record(station, varargin)

varargin = read_varargin2(varargin, {'Clean'});


record = [];  % x, y, z, time, t, s
ii = 0;


for i = 1 : length(station)
    
    for ista = 1 : length(station{i})
        
        for it = 1 : length(station{i}(ista).time)
            for iz = 1 : length(station{i}(ista).depth)
                ii = ii + 1;
                record(ii, 1) = station{i}(ista).lon;
                record(ii, 2) = station{i}(ista).lat;
                record(ii, 3) = station{i}(ista).depth(iz);
                record(ii, 4) = station{i}(ista).time(it);
                record(ii, 5) = i;
                record(ii, 6) = ista;
                
                
                for iv = 1 : length(varargin)
                    if isfield(station{i}(ista), varargin{iv})
                        cmd = ['record(ii, iv+6) = station{i}(ista).' varargin{iv} '(iz, it);'];
                        eval(cmd);
                    else
                        record(ii, iv+6) = nan;
                    end
                end
                
            end
        end
        
    end
    
end
                
if Clean
%     data = record(:, 7 : end);
    k = all(isnan(record(:,7:end)),2);
    record(k, :) = [];
end


end