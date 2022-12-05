%==========================================================================
% Calculate FVCOM sigma varaibles 
%
% input  :
%   fgrid
%   sigma
% 
% output :
%   fgrid
%
% Siqi Li, SMAST
% 2022-11-30
%
% Updates:
%
%==========================================================================
function fgrid = f_calc_sigma(fgrid, sigma)

h = fgrid.h;
nv = fgrid.nv;
kb = sigma.nz;
kbm1 = kb - 1;
siglev = zeros(fgrid.node, kb);



switch sigma.type
    case 'UNIFORM'
        for iz = 1 : kb
            siglev(:,k) = -(iz-1) / (kb-1);
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
        for i = 1 : fgrid.node
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
                for iz = 2 : sigma.ku+1
                    siglev(i,iz) = siglev(i,iz-1) - sigma.zku(iz-1)/h(i);
                end
                for iz = sigma.ku+2 : kb-sigma.kl
                    siglev(i,iz) = siglev(i,iz) - DR;
                end
                KK = 0;
                for iz = kb-sigma.kl+1 : kb
                    KK = KK+1;
                    siglev(i,iz) = siglev(i,iz-1) - sigma.zkl(KK)/h(i);
                end
            end
        end
end


siglay = (siglev(:,1:kbm1) + siglev(:,2:kb)) / 2;

fgrid.kbm1 = size(siglay, 2);
fgrid.kb = fgrid.kbm1 + 1;

%------------Sigma of each layer and level---------------------------------
% Node
fgrid.siglay = siglay;
fgrid.siglev = siglev;

% Cell
fgrid.siglayc=squeeze(mean(reshape(siglay(nv,:), fgrid.nele, 3, fgrid.kbm1), 2));
fgrid.siglevc = zeros(fgrid.nele, fgrid.kb);
for i = 2 : fgrid.kb
    fgrid.siglevc(:, i) = fgrid.siglayc(:, i-1)*2 - fgrid.siglevc(:, i-1);
end

%------------Depth of each layer and level---------------------------------

% Node
fgrid.deplay = -fgrid.siglay .* repmat(fgrid.h, 1, fgrid.kbm1);
fgrid.deplev = -fgrid.siglev .* repmat(fgrid.h, 1, fgrid.kb);

% Cell
fgrid.deplayc = -fgrid.siglayc .* repmat(fgrid.hc, 1, fgrid.kbm1);
fgrid.deplevc = -fgrid.siglevc .* repmat(fgrid.hc, 1, fgrid.kb);
    

