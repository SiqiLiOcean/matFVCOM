%==========================================================================
% Merge the obs struct according to (lon,lat)
%
% input  :
%   obs --- obs struct (containing lon, lat, depth, time, and other variables)
% 
% output :
%   out --- output obs struct
%
% Siqi Li, SMAST
% 2022-06-17
%
% Updates:
%
%==========================================================================
function out = obs_merge_location(obs, varargin)


if isempty(obs)
    out = obs;
end

varargin = read_varargin(varargin, {'eps'}, {1e-5});


n = length(obs);
lon = [obs.lon];
lat = [obs.lat];

% Variable list
list = fieldnames(obs);
list = list(~contains(fieldnames(obs), {'lon', 'lat', 'depth', 'time'}));

% 1. check if the data sizes are right on nz and nt.
for i = 1 : n
    obs(i).depth = obs(i).depth(:)';

    nz0(i) = length(obs(i).depth);
    nt0(i) = length(obs(i).time);
    for k = 1 : length(list)
        if all(size(obs(i).(list{k})) == [nz0(i) nt0(i)])
            % the size is right
        elseif all(size(obs(i).(list{k})) == [nt0(i) nz0(i)])
            obs(i).(list{k}) = obs(i).(list{k})';
        else
            error(['The data size is wrong: ' list{k} '(' num2str(i) ')'])
        end
    end
end


% 2. Merge the data based on the location
lonlat = unique([lon(:) lat(:)], 'rows');
for i = 1 : size(lonlat, 1)

    out(i).lon = lonlat(i, 1);
    out(i).lat = lonlat(i, 2);
    
    id = find(sqrt((lon-lonlat(i,1)).^2 + (lat-lonlat(i,2)).^2) < eps);

    depth = sort(unique([obs(id).depth]));
    depth = depth(~isnan(depth));
    time = sort(unique([obs(id).time]));
    time = time(~isnan(time));
    
    nz = length(depth);
    nt = length(time);

    out(i).depth = depth(:);
    out(i).time = time;
%     out(i).id = id;
    for k = 1 : length(list)
        tmp = nan(nz, nt);
        for j = 1 : length(id)


            for jt = 1 : nt0(id(j))

                jtime = obs(id(j)).time(jt);
                jt2 = find(time==jtime, 1);

                jdepth = obs(id(j)).depth;
                jz1 = knnsearch(jdepth(:), depth(:))';
                jz2 = find(ismember(depth, jdepth));
                jz = jz1(jz2);

                tmp(jz2, jt2) = obs(id(j)).(list{k})(jz, jt);

            end

        end
        out(i).(list{k}) = tmp;
    end
end






