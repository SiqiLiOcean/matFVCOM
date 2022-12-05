%==========================================================================
% this is the function rewrite from ERSEM to calculate pH and pCO2 from TA
%
% input  :
%   P is water pressure in dbar
%   T is water temperature in oC
%   S is water salinity in PSU
%   CTOT is DIC
%   TA is alkanility
%   hscale is pH scale
%
% output :
%   pH
%   pCO2
%
% Lu Wang, SMAST
% 2022-03-01
%
% Updates:
% 2022-03-03  Lu Wang  Vectorization 
%==========================================================================
function [pH,pCO2]=CO2dyn(T,S,P,CTOT,TA,BORON,hscale)


TA=TA/10^6;
CTOT=CTOT/10^6;
T=max(T,0);

BTOT=0.0004128*S/35;

[k0co2,k1co2,k2co2,kb]=CO2SET(P*0.1,T,S,hscale);

n=length(T(:));
for in=1:n
    [pH(in),pCO2(in),success(in)]=CO2CLC(k0co2(in),k1co2(in),k2co2(in),kb(in),BORON,BTOT(in),CTOT(in),TA(in));
end

pH(success==0) = nan;
pCO2(success==0) = nan;


end

%==========================================================================
%co2set
function [k0co2,k1co2,k2co2,kb]=CO2SET(P,T,S,hscale)
% P is water pressure in dbar
% T is water temperature in oC
% S is water salinity in PSU

%parameter
Rgas=83.131;
%Derive simple terms used more than once
TK=T+273.15;
invtk=1./TK;
dlogTK=log(TK);
TK100=TK/100;
S2=S.*S;
sqrts=sqrt(S);
S15=S.^(1.5);

%is : ionic strength, needed to calculate ks 
is = 19.924*S./(1000-1.005*S);
sqrtis=sqrt(is);

%cl : Chloride concentration, used to calculate total sulphate and total fluoride
cl = S/1.80655;

%st : total sulfate using Morris  Riley, Deep Sea Research, 1966
%0.14 is the S:Cl ratio observed, 96.065 is the molecular weight of SO4
st=0.14*cl/96.065;

% ks = [H][SO4]/[HSO4] in free scale from Dickson, J. chem. Thermodynamics, 1990 and Perez  Frega, Mar Chem, 1987
ks=exp(-4276.1*invtk + 141.328 - 23.093*dlogTK ...
           + (-13856.0*invtk + 324.57 - 47.986*dlogTK) .* sqrtis ...
           + (35474.0*invtk - 771.54 + 114.723*dlogTK) .* is ...
           - 2698.0*invtk.*is.^1.5 + 1776.0*invtk.*is.^2. ...
           + log(1.0 - 0.001005*S));

%ft : total fluoride using Riley, Analytica chimica Acta, 1966
%0.000067 is the F:Cl ratio observed, 19.9984 is the molecular weight of F-
ft=0.000067*cl/19.9984;

%kf = [H][F]/[HF] in total scale from Perez and Fraga (1987)
%Formulation as given in Dickson et al. (2007)
kf = exp(874.0*invtk - 9.68 + 0.111*sqrts);

%this is the conversion factor from total scale to free scale at surface
total2free_surface = 1./(1.0 + st./ks);
%this is the conversion factor from free to SWS at surface
free2sws_surface= 1.0 + st./ks + ft./kf;
%this is the conversion factor from total to SWS at surface
total2sws_surface= total2free_surface.*free2sws_surface;

%Correction for high pressure (from Mocsy)
delta=-18.03+0.0466*T+0.000316*T.^2.;
kappa=-4.53+0.00009*T;
ks=ks.*exp((-delta+0.5*kappa.*P).*P./(Rgas.*TK));
%this is the conversion factor from total scale to free scale at depth
total2free_depth = 1./(1.0 + st./ks);

%Correction for high pressure (from Mocsy) - this requires kf being in free scale, final value still in total scale
delta=-9.78-0.009*T-0.000942*T.^2.;
kappa=-3.91+0.000054*T;
kf=kf.*total2free_surface.*exp((-delta+0.5*kappa.*P).*P./(Rgas.*TK))./total2free_depth;
%this is the conversion factor from free to SWS at depth
free2sws_depth= 1.0 + st./ks + ft./(kf.*total2free_depth);
%this is the conversion factor from total to SWS at surface
total2sws_depth= total2free_depth.*free2sws_depth;

%Calculation of constants as used in the OCMIP process for ICONST = 3 or 6
%see http://www.ipsl.jussieu.fr/OCMIP/
%k0co2 = CO2/fCO2 from Weiss 1974
k0co2 = exp(93.4517./TK100 - 60.2409 + 23.3585 * log(TK100) + ...
           S .* (0.023517 - 0.023656 * TK100 + 0.0047036 * TK100 .^ 2.));

%correction for high pressure from Weiss 1974
%vbarCO2 = 32.3      partial molal volume (cm3 / mol) from Weiss (1974, Appendix, paragraph 3)
%P is in bar, hence the reference is 1.01325 instead of 1 as in Weiss 1974
k0co2 = k0co2 .* exp( ((1.01325-P)*32.3)./(Rgas.*TK) );
%kb = [H][BO2]/[HBO2]
%Millero p.669 (1995) using data from Dickson (1990)
kb=exp((-8966.9 - 2890.53*sqrts - 77.942*S + ...
           1.728*S15 - 0.0996*S2)./TK + ...
           (148.0248 + 137.1942*sqrts + 1.62142*S) + ...
           (-24.4344 - 25.085*sqrts - 0.2474*S) .* dlogTK + ...
           0.053105*sqrts.*TK);

%k1co2 = [H][HCO3]/[H2CO3]
%k2co2 = [H][CO3]/[HCO3]
if (hscale==-1)
    % if phscale = -1 then we use old formulation for backward compatibility
    % Millero p.664 (1995) using Mehrbach et al. data on seawater scale
    % kb is left in total scale because this was in the old formulation
    k1co2=10.^(-1*(3670.7./TK - 62.008 + 9.7944*dlogTK - ...
        0.0118*S + 0.000116*S2));
    k2co2=10.^(-1*(1394.7./TK + 4.777 - ...
        0.0184*S + 0.000118*S2));
elseif (hscale==0)
    % if phscale = 0 then we use  Millero 2010 on seawater scale
    % kb is converted in seawater scale
    pk1co2 = -126.34048+6320.813*invtk+19.568224*dlogTK + ...
        (13.4038*sqrts + 0.03206*S - 0.00005242*S.^2.0) + ...
        (-530.659 *sqrts - 5.8210 *S) .* invtk + ...
        (-2.0664 *sqrts).*dlogTK;
    k1co2 =10.^(-pk1co2);
    pk2co2 = -90.18333+5143.692*invtk+14.613358*dlogTK + ...
        (21.3728*sqrts + 0.1218*S - 0.0003688*S.^2.0) + ...
        (-788.289 *sqrts - 19.189 *S) .* invtk + ...
        (-3.374 *sqrts).*dlogTK;
    k2co2=10.^(-pk2co2);
    kb=kb.*total2sws_depth;
elseif (hscale==1)
    % if phscale = 1 then we use  Millero 2010 on total scale
    pk1co2 = -126.34048+6320.813*invtk+19.568224*dlogTK + ...
        (13.4051*sqrts + 0.03185*S - 0.00005218*S.^2.0) + ...
        (-531.095 *sqrts - 5.7789 *S) .* invtk + ...
        (-2.0663 *sqrts).*dlogTK;
    k1co2 = 10.^(-pk1co2);
    pk2co2 = -90.18333+5143.692*invtk+14.613358*dlogTK +...
        (21.5724*sqrts + 0.1212*S - 0.0003714*S.^2.0) + ...
        (-798.292 *sqrts - 18.951 *S) .* invtk + ...
        (-3.403 *sqrts).*dlogTK;
    k2co2=10.^(-pk2co2);
else
    error('hscale should be -1, 0, or 1.')
end


% here k1, k2, kb are corrected for high pressure using Millero 1995
% please not that MOCSY assume that this correction is valid for SWSscale, 
% so it first convert everything to SWS then back to total
% differences are minimal
% correction of k1co2
delta=-25.5+0.1271*T;
kappa=(-3.08+0.0877*T)/1000.;
k1co2=k1co2.*exp((-delta+0.5*kappa.*P).*P./(Rgas.*TK));

% Correction for k2co2
delta=-15.82-0.0219*T;
kappa=(1.13-0.1475*T)/1000.;
k2co2=k2co2.*exp((-delta+0.5*kappa.*P).*P./(Rgas.*TK));

% Correction for kb
delta=-29.48+0.1622*T-0.002608*T.^2.;
kappa=-2.84/1000.;
kb=kb.*exp((-delta+0.5*kappa.*P).*P/(Rgas.*TK));

end


%==========================================================================
%co2clc
function [PH,PCO2,success]=CO2CLC(k0co2,k1co2,k2co2,kb,BORON,BTOT,CTOT,TA)


PCO2=10^-6;

%  DERIVING PH REQUIRES FOLLOWING LOOP TO CONVERGE.
%  THIS SUBROUTINE RELIES ON CONVERGENCE.  if THE ENVIRONMENTAL
%  CONDITIONS DO NOT ALLOW FOR CONVERGENCE (IN 3D MODEL THIS IS
%  LIKELY TO OCCUR NEAR LOW SALINITY REGIONS) THE MODEL WILL
%  BE STUCK IN THE LOOP.  TO AVOID THIS A CONVERGENCE CONDITION
%  IS PUT IN PLACE TO SET A FLAGG OF -99 IN THE PH VAR FOR NON CONVEGENCE.
%  THE MODEL IS  ALLOWED TO CONTINUE. 'COUNTER, C_SW,C_CHECK' ARE
%  THE LOCAL VARS USED.
% C_SW = condition of convergence 0=yes, 1= no
% COUNTER = number of iterations
% C_CHECK = maximum number of iterations
success = 1;
DONE = 0;
% SET COUNTER AND SWITCH TO ZERO AND OFF
COUNTER=0;
C_SW=0;
% FROM EXPERIENCE if THE ITERATIONS IN THE FOLLOWING DO LOOP
% EXCEEDS 15 CONVERGENCE WILL NOT OCCUR.  THE OVERHEAD OF 25 ITERATIONS
% IS OK FOR SMALL DOMAINS WITH 1/10 AND 1/15 DEG RESOLUTION.
% I RECOMMEND A LOWER VALUE OF 15 FOR HIGHER RESOLUTION OR LARGER DOMAINS.
C_CHECK=25;

AKR = k1co2/k2co2;
% AHPLUS=10.^(-PH);
% PROD=AKR*k0co2*PCO2;

if (BORON)
    % TA, BTOT AND CTOT FIXED ***
    % ITERATIVE CALCULATION NECESSARY HERE
    
    % SET INITIAL GUESSES AND TOLERANCE
    
    H2CO3=PCO2*k0co2;
    CO3=TA/10.;
    AHPLUS=1.e-8;
    ALKB=BTOT;
    TOL1=TA/1.e5;
    TOL2=H2CO3/1.e5;
    TOL3=CTOT/1.e5;
    TOL4=BTOT/1.e5;
    % HALTAFALL iteration to determine CO3, ALKB, AHPLUS
    KARL=1;
    STEG=2.;
    FAK=1.;
    STEGBY=0.4;
    
    while (~DONE)
        DONE=1;
        
        % SET COUNTER UPDATE.
        COUNTER=COUNTER+1;
        % CHECK if CONVERGENCE HAS OCCURED IN THE NUMBER OF
        % ACCEPTABLE ITTERATIONS.
        if (COUNTER>=C_CHECK)
            % LOG FILE TO SHOW WHEN AND WHERE NON CONVERGENCE OCCURS.
            % if NON CONVERGENCE, THE MODEL REQUIRES CONCS TO CONTAIN USABLE VALUES.
            % BEST OFFER BEING THE OLD CONCS VALUES WHEN CONVERGENCE HAS BEEN
            % ACHIEVED
            success = 0;
            
            % RESET SWITCH FOR NEXT CALL TO THIS SUBROUTINE
            C_SW=0;
            return
        end
        
        % *** CTOT IS FIXED ***
        Y=CO3*(1.+AHPLUS/k2co2+AHPLUS*AHPLUS/(k1co2*k2co2));
        if (abs(Y-CTOT)>TOL3)
            CO3=CO3*CTOT/Y;
            DONE=0;
        end
        Y=ALKB*(1.+AHPLUS/kb);
        if (abs(Y-BTOT)>TOL4)
            ALKB=ALKB*BTOT/Y;
            DONE=0;
        end
        % Alkalinity is equivalent to -(total H+), so the sign of W is opposite
        % to that normally used
        
        Y=CO3*(2.+AHPLUS/k2co2)+ALKB;
        if (abs(Y-TA)>TOL1)
            DONE=0;
            X=log(AHPLUS);
            W=sign(Y-TA);
            if (W>=0.)
                X1=X;
                Y1=Y;
            else
                X2=X;
                Y2=Y;
            end
            LQ=KARL;
            if (LQ==1)
                KARL=2*round(W);
            elseif (abs(LQ)==2 && (LQ*W)<0.)
                FAK=0.5;
                KARL=3;
            end
            
            if (KARL==3 && STEG<STEGBY)
                W=(X2-X1)/(Y2-Y1);
                X=X1+W*(TA-Y1);
            else
                STEG=STEG*FAK;
                X=X+STEG*W;
            end
            AHPLUS=exp(X);
        end
        % LOOP BACK UNTIL CONVERGENCE HAS BEEN ACHIEVED
        % OR MAX NUMBER OF ITERATIONS (C_CHECK) HAS BEEN REACHED.
    end
    
    HCO3=CO3*AHPLUS/k2co2;
    H2CO3=HCO3*AHPLUS/k1co2;
    PCO2=H2CO3/k0co2;
    PH=-log10(AHPLUS);
    ALKC=TA-ALKB;
end
PCO2=PCO2*10^6;
end

