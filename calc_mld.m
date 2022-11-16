%==========================================================================
% Calculate mixed layer depth
%
% input  :
%   depth --- layer depth, positive for water, m (node, nz)
%   rho   --- density, kg/m3 (node, nz)
% 
% output :
%   mld   --- mixed layer depth, m (node)
%
% Siqi Li, SMAST
% 2021-08-12
%
% Updates:
%
%==========================================================================
function mld = calc_mld(depth, rho, varargin)

% Set the parameters
read_varargin(varargin, {'DEEPWATER_DEPTH'}, {100.0});
read_varargin(varargin, {'DEEPWATER_GAMMA'}, {0.03});
read_varargin(varargin, {'MLD_MAX'}, {200});
read_varargin(varargin, {'MLD_DEFAULT'}, {5});
read_varargin(varargin, {'GAMMA_MIN'}, {0.04});  
                               
% [node, nz] = size(depth);

% Convert density to sigma
% rho = rho - 1000;

gamma = calc_max_k(depth, rho, varargin);

[std_depth, std_rho] = vertical_interp_rho(depth, rho, varargin);

mld = calc_mld_density(std_depth, std_rho, gamma, varargin);

end

%==========================================================================
function gamma = calc_max_k(depth, rho, varargin)

% Set the parameters
read_varargin(varargin, {'DEEPWATER_DEPTH'}, {100.0});
read_varargin(varargin, {'DEEPWATER_GAMMA'}, {0.03});

[node, nz] = size(depth);

k = (rho(:,2:nz) - rho(:,1:nz-1)) ./ (depth(:,2:nz) - depth(:,1:nz-1));

gamma = max(k,[],2);

gamma(depth(:,nz)>DEEPWATER_DEPTH) = DEEPWATER_GAMMA;

end

%==========================================================================
function [std_depth, std_rho] = vertical_interp_rho(depth, rho, varargin)

% Set the parameters
read_varargin(varargin, {'MLD_MAX'}, {200});

std_nz = round(MLD_MAX) + 1;
missing_value = nan;

[node, nz] = size(depth);

std_depth = zeros(node, std_nz);
std_rho = zeros(node, std_nz);

for i = 1 : node
    if (depth(i,nz) < nz)
        std_depth(i, 1) = 0;
        std_depth(i, 2:nz+1) = depth(i, 1:nz);
        std_depth(i, nz+2:std_nz) = missing_value;
        
        std_rho(i, 1) = rho(i, 1);
        std_rho(i, 2:nz+1) = rho(i, 1:nz);
        std_rho(i, nz+2:std_nz) = missing_value;
    else
        std_depth(i, :) = 0 : std_nz-1;
        std_rho(i, :) = v_interp(depth(i, :), rho(i, :), std_depth(i, :));
    end
end

end

%==========================================================================
function y2 = v_interp(x1, y1, x2)

missing_value = nan;
n1 = length(x1);
n2 = length(x2);

y2 = nan(n2, 1);

for j=1:n2
    if (x2(j)<x1(1)) % If shallower than the first sigma layer
        y2(j)=y1(1);
    elseif (x2(j)>x1(n1)) % If deeper than the last sigma layer
        y2(j)=missing_value;
    else
        for i=2:n1
            if (x2(j)>=x1(i-1) && x2(j)<=x1(i))
                a1=x1(i-1);
                a=x2(j);
                a2=x1(i);
                w1=(a2-a)/(a2-a1);
                w2=(a-a1)/(a2-a1);
                y2(j)=y1(i-1)*w1+y1(i)*w2;
            end
        end
    end
end

end

%==========================================================================
function mld = calc_mld_density(depth, rho, gamma, varargin)

% Set the parameters
read_varargin(varargin, {'DEEPWATER_DEPTH'}, {100.0});
read_varargin(varargin, {'MLD_DEFAULT'}, {5});
read_varargin(varargin, {'GAMMA_MIN'}, {0.04});                    
                    
[node, nz] = size(depth);


mld = zeros(node, 1);

for i = 1 : node
    
    iz = sum(~isnan(rho(i,:)));
    
    if (abs(gamma(i))<GAMMA_MIN && depth(i, iz)<DEEPWATER_DEPTH) 
        mld(i) = depth(i, iz);
        
    else
        h = (rho(i, 1:iz-1) + rho(i, 2:iz))/2 * (depth(i, 2:iz) - depth(i, 1:iz-1))';
        vdif = h - rho(i, 1) * (depth(i, iz) - depth(i, 1));
        
        if (vdif<0)
            mld(i) = min(MLD_DEFAULT, depth(i, iz));
        else
            mld(i) = depth(i, iz) - sqrt(2*vdif/gamma(i));
        end
        
        if (mld(i)<0)
            mld(i) = min(MLD_DEFAULT, depth(i, iz));
        end
    end
    
end

end