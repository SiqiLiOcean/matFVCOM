%==========================================================================
% Calculate 'real' air temperature from potential tempearture and pressure
% input  :
%   --- pt,   potential temperature (degree C)
%   --- pres, pressure              (hPa)
%
% output :
%   --- tc,   temperature           (degree C)
%
% Siqi Li, SMAST
% 2021-06-30
%
% Updates:
%
%==========================================================================
function tc = calc_tc(pt, pres)

p0 = 1000;         % standard pressure (hPa)
Rd=287.04;         % real gas constant for air     (m2 K-1 s-2)
Cp=7.*Rd/2.;       % pecific heat
RCP=Rd/Cp;         

tc = (pt+273.15) .* (pres/p0).^RCP;

tc = tc - 273.15;

end