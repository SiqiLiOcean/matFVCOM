%==========================================================================
% Calculate the FVCOM sigma layer and level depths
%
% input  :
%   h     --- water depth (positive for water)
%   sigma ---
%
% output :
%
% Siqi Li, SMAST
% 2022-12-27
%
% Updates:
%
%==========================================================================
function [siglay, siglev, deplay, deplev] = calc_sigma(h, sigma)

kb = sigma.nz;
kbm1 = kb - 1;
siglev = zeros(length(h), kb);
h = h(:);

switch upper(sigma.type)
    case 'UNIFORM'
        for iz = 1 : kb
            siglev(:,iz) = -(iz-1) / (kb-1);
        end

    case 'GEOMETRIC'
        if mod(kb, 2) == 0
            error('When using GEOMETRIC, nz has to be odd.')
        end
        for iz = 1 : (kb+1)/2
            siglev(:,iz) = -( (iz-1) / ((kb+1)/2-1) )^sigma.sigma_power / 2;
        end
        for iz =  (kb+1)/2+1 : kb
            siglev(:,iz) = -( (kb-iz) / ((kb+1)/2-1) )^sigma.sigma_power / 2 - 1;
        end

    case 'TANH'
        for iz = 1 : kbm1
            x1 = sigma.dl + sigma.du;
            x1 = x1 * (kbm1-iz) / kbm1;
            x1 = x1 - sigma.dl;
            x1 = tanh(x1);
            x2 = tanh(sigma.dl);
            x3 = x2 + tanh(sigma.du);

            siglev(:,iz+1) = (x1 + x2) / x3 - 1;
        end

    case 'GENERALIZED'
        for i = 1 : length(h)
            if h(i) < sigma.min_const_depth
                DL2 = 0.001;
                DU2 = 0.001;
                for iz = 1 : kbm1
                    x1 = DL2 + DU2;
                    x1 = x1 * (kbm1-iz) / kbm1;
                    x1 = x1 - DL2;
                    x1 = tanh(x1);
                    x2 = tanh(DL2);
                    x3 = x2 + tanh(DU2);

                    siglev(i, iz+1) = (x1+x2) / x3 - 1;
                end
            else
                DR = (h(i)-sigma.du-sigma.dl) / h(i) / (kb-sigma.ku-sigma.kl-1);
                for iz = 2 : sigma.ku+1 % Upper
                    siglev(i,iz) = siglev(i,iz-1) - sigma.zku(iz-1)/h(i);
                end
                for iz = sigma.ku+2 : kb-sigma.kl  % Middle
                    siglev(i,iz) = siglev(i,iz-1) - DR;
                end
                KK = 0;
                for iz = kb-sigma.kl+1 : kb % Lower
                    KK = KK+1;
                    siglev(i,iz) = siglev(i,iz-1) - sigma.zkl(KK)/h(i);
                end
            end
        end
end

siglay = (siglev(:,1:kbm1) + siglev(:,2:kb)) / 2;

deplay = -siglay .* repmat(h, 1, kbm1);
deplev = -siglev .* repmat(h, 1, kb);
