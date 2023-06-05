%==========================================================================
% Interp FVCOM temperature and salinity results to observation points
%
% input  :
%   fgrid    --- fvcom grid
%   mod_time --- model time
%   mod_u    --- current u
%   obs      --- observation structure read via read_ts
% 
% output :
%   mod_zt
%   data_u
%
% Siqi Li, SMAST
% 2022-11-08
%
% Updates:
%==========================================================================
function [mod_zt, data_u, source] = f_interp_u(fgrid, mod_time, mod_u, obs)


n = length(obs);


id = ksearch([fgrid.xc fgrid.yc], [[obs.x]' [obs.y]']);
for i = 1 : n
    u0 = squeeze(mod_u(id(i),:,:)); 
    for it = 1 : length(mod_time)
        mod_zt(i).U(:,it) = interp_vertical(u0(:,it)', fgrid.deplayc(id(i), :), obs(i).depth');
    end
end

data_u = [];
source = [];
for i = 1 : n
    data_u = [data_u; obs(i).U(:) mod_zt(i).U(:)];
    source = [source; repmat(convertCharsToStrings(obs(i).source),obs(i).nz*obs(i).nt,1)];
end

end
