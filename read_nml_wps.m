%==========================================================================
% Read the WPS namelist file (with default settings)
%
% input  :
%   fnml --- input WPS namelist file path and name
% 
% output :
%   nml  --- WPS namelist struct
%
% Siqi Li, SMAST
% 2022-03-17
%
% Updates:
%
%==========================================================================
function nml = read_nml_wps(fnml)


% Read the input nml
nml1 = read_nml(fnml);

% Read the default nml
nml0 = nml_default_wps(nml1.share.max_dom);

nml = merge_nml(nml0, nml1);

if isnan(nml.geogrid.truelat2)
    nml.geogrid.truelat2 = nml.geogrid.truelat1;
end

end
        
        
        