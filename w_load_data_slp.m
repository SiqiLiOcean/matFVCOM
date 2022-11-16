%==========================================================================
%  Load the WRF grid from WRF output
% 
% Input  : --- fwrf, WRF output file path and name
%
% Output : --- data, data cell containing variables to calculate slp
% 
% Usage  : wgrid = w_load_grid(fwrf);
%
% v1.0
%
% Siqi Li
% 2021-05-07
%
% Updates:
%
%==========================================================================
function data = w_load_data_slp(fwrf, varargin)


t1 = 1;


% Read the dimension length of Time
ncid = netcdf.open(fwrf, 'NC_NOWRITE');
nt_dimid = netcdf.inqDimID(ncid, 'Time');
[~, t2] = netcdf.inqDim(ncid, nt_dimid);
netcdf.close(ncid);


if ~isempty(varargin)
    t1 = varargin{1};
    t2 = varargin{2};
end


nt = t2 - t1 + 1;

% Read the six variables needed for calculating slp
P      = ncread(fwrf, 'P',      [1 1 1 t1], [Inf Inf Inf nt]);
PB     = ncread(fwrf, 'PB',     [1 1 1 t1], [Inf Inf Inf nt]);
T      = ncread(fwrf, 'T',      [1 1 1 t1], [Inf Inf Inf nt]);
QVAPOR = ncread(fwrf, 'QVAPOR', [1 1 1 t1], [Inf Inf Inf nt]);
PH     = ncread(fwrf, 'PH',     [1 1 1 t1], [Inf Inf Inf nt]);
PHB    = ncread(fwrf, 'PHB',    [1 1 1 t1], [Inf Inf Inf nt]);

data.P      = P;
data.PB     = PB;
data.T      = T;
data.QVAPOR = QVAPOR;
data.PH     = PH;
data.PHB    = PHB;

disp(' ')
disp('------------------------------------------------')
disp('The following variables were read to calculate SLP:')
disp(['   P     : ' num2str(size(P))])
disp(['   PB    : ' num2str(size(PB))])
disp(['   T     : ' num2str(size(T))])
disp(['   QVAPOR: ' num2str(size(QVAPOR))])
disp(['   PH    : ' num2str(size(PH))])
disp(['   PHB   : ' num2str(size(PHB))])
disp('------------------------------------------------')
disp(' ')
