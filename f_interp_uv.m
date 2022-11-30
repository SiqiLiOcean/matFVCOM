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
function [mod_zt, data_u, data_v, source] = f_interp_uv(fgrid, mod_time, mod_u, mod_v, obs)


n = length(obs);


id = knnsearch([fgrid.xc fgrid.yc], [[obs.x]' [obs.y]']);
for i = 1 : n
    u0 = squeeze(mod_u(id(i),:,:)); 
    v0 = squeeze(mod_v(id(i),:,:)); 
    for it = 1 : length(mod_time)
        mod_zt(i).U(:,it) = interp_vertical(u0(:,it)', fgrid.deplayc(id(i), :), obs(i).depth');
        mod_zt(i).V(:,it) = interp_vertical(v0(:,it)', fgrid.deplayc(id(i), :), obs(i).depth');
    end
end

% % for i = 1 : n
% %     if mod(i, 20) == 0
% %         disp(['-------' num2str(i, '%4.4d') ' / ' num2str(n, '%4.4d')])
% %     end
% %     
% % %     % Interpolate only on time
% % %     mod_t(i).T = f_interp_xyt(f, mod_time, t0, obs(i).x, obs(i).y, obs(i).time);
% % %     mod_t(i).S = f_interp_xyt(f, mod_time, s0, obs(i).x, obs(i).y, obs(i).time);
% % 
% % %     % Interpolate only on depth
% % %     mod_z(i).U = f_interp_xyz(fgrid, mod_u, obs(i).x,obs(i).y, obs(i).depth);
% % %     mod_z(i).V = f_interp_xyz(fgrid, mod_v, obs(i).x,obs(i).y, obs(i).depth);
% % %     weight_t = interp_time_calc_weight(mod_time, obs(i).time);
% % %     for iz = 1 : obs(i).nz
% % %         mod_zt(i).U(iz,:) = interp_time_via_weight(mod_z(i).U(iz,:), weight_t);
% % %         mod_zt(i).V(iz,:) = interp_time_via_weight(mod_z(i).V(iz,:), weight_t);
% % %     end
% % 
% %     % Interpolate on both time and depth
% %     mod_zt(i).U = f_interp_xyzt(fgrid, mod_time, mod_u, obs(i).x,obs(i).y, obs(i).depth, obs(i).time);
% %     mod_zt(i).V = f_interp_xyzt(fgrid, mod_time, mod_v, obs(i).x,obs(i).y, obs(i).depth, obs(i).time);    
% % end

data_u = [];
data_v = [];
source = [];
for i = 1 : n
    data_u = [data_u; obs(i).U(:) mod_zt(i).U(:)];
    data_v = [data_v; obs(i).V(:) mod_zt(i).V(:)];
    source = [source; repmat(convertCharsToStrings(obs(i).source),obs(i).nz*obs(i).nt,1)];
end

end