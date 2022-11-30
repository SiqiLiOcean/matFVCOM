%==========================================================================
% Interp FVCOM temperature and salinity results to observation points
%
% input  :
%   fgrid    --- fvcom grid
%   mod_time --- model time
%   mod_t    --- temperature results
%   mod_s    --- salinity results
%   obs      --- observation structure read via read_ts
% 
% output :
%   mod_zt
%   data_t
%   data_s
%
% Siqi Li, SMAST
% 2022-11-08
%
% Updates:
%
%==========================================================================
function [mod_zt, data_t, data_s] = f_interp_ts(fgrid, mod_time, mod_t, mod_s, obs)


n = length(obs);


for i = 1 : n
    if mod(i, 20) == 0
        disp(['-------' num2str(i, '%4.4d') ' / ' num2str(n, '%4.4d')])
    end
    
%     % Interpolate only on time
%     mod_t(i).T = f_interp_xyt(f, mod_time, t0, obs(i).x, obs(i).y, obs(i).time);
%     mod_t(i).S = f_interp_xyt(f, mod_time, s0, obs(i).x, obs(i).y, obs(i).time);

%     % Interpolate only on depth
%     mod_z(i).T = f_interp_xyz(fgrid, mod_t, obs(i).x,obs(i).y, obs(i).depth);
%     mod_z(i).S = f_interp_xyz(fgrid, mod_s, obs(i).x,obs(i).y, obs(i).depth);
%     weight_t = interp_time_calc_weight(mod_time, obs(i).time);
%     for iz = 1 : obs(i).nz
%         mod_zt(i).T(iz,:) = interp_time_via_weight(mod_z(i).T(iz,:), weight_t);
%         mod_zt(i).S(iz,:) = interp_time_via_weight(mod_z(i).S(iz,:), weight_t);
%     end

    % Interpolate on both time and depth
    mod_zt(i).T = f_interp_xyzt(fgrid, mod_time, mod_t, obs(i).x,obs(i).y, obs(i).depth, obs(i).time);
    mod_zt(i).S = f_interp_xyzt(fgrid, mod_time, mod_s, obs(i).x,obs(i).y, obs(i).depth, obs(i).time);    
end

data_t = [];
data_s = [];
for i = 1 : n

    data_t = [data_t; obs(i).T(:) mod_zt(i).T(:) ones(obs(i).nz*obs(i).nt,1)*obs(i).source];
    data_s = [data_s; obs(i).S(:) mod_zt(i).S(:) ones(obs(i).nz*obs(i).nt,1)*obs(i).source];
    
end

end