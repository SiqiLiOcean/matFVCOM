%==========================================================================
% Write FVCOM tidal forcing NetCDF file
% 
% Input  : 
% fout       --- tidal forcing file path and name
% time_origin--- time0, time in MATLAB datenum format
% obc        --- open boundary node ids
% period     --- period, tide angular period (s)
% eref       --- elevation reference (m)
% amplitude  --- amp, tidal component amplitude (m)
% phase      --- pha, tidal component phase (degree)
%
% Output : \
% 
% Usage  : write_tidal_spectral(fini, zsl, datenum(2012, 10, 18, 0, 0, 0]), 'tsl', T);
%
% v1.0
%
% Lu Wang
% 2023-02-13
%
% Updates:
%
%==========================================================================

function write_obc_spectral(fout, time_origin , obc, eref, period, amplitude, phase, varargin)

varargin = read_varargin2(varargin, {'Ideal'});

nobc = size(amplitude,1);
ntc = size(amplitude,2);

% Generate the four time variables
time = convert_fvcom_time(time_origin, Ideal);


% create the output file.
ncid=netcdf.create(fout, 'CLOBBER');

%define the dimension
nobc_dimid=netcdf.defDim(ncid, 'nobc', nobc);
tidal_components_dimid=netcdf.defDim(ncid,'tidal_components',ntc);
% DateStrLen_dimid=netcdf.defDim(ncid,'DateStrLen',26);

%define variables
% time_origin
time_origin_varid = netcdf.defVar(ncid, 'time_origin','float', []);
if ~isempty(Ideal)
    netcdf.putAtt(ncid,time_origin_varid, 'time_zone','none');
    netcdf.putAtt(ncid,time_origin_varid, 'units','days since 0.0');
else
    netcdf.putAtt(ncid,time_origin_varid, 'time_zone','UTC');
end

% obc_nodes
obc_nodes_varid = netcdf.defVar(ncid, 'obc_nodes', 'int', nobc_dimid);
netcdf.putAtt(ncid,obc_nodes_varid, 'long_name', 'Open Boundary Node Number');
netcdf.putAtt(ncid,obc_nodes_varid, 'grid', 'obc_grid');

% tide_Eref
tide_Eref_varid = netcdf.defVar(ncid,'tide_Eref','float',nobc_dimid);
netcdf.putAtt(ncid, tide_Eref_varid, 'long_name','tidal elevation reference level');
netcdf.putAtt(ncid, tide_Eref_varid, 'units','meters');

% tide_period
tide_period_varid = netcdf.defVar(ncid,'tide_period','float',tidal_components_dimid);
netcdf.putAtt(ncid, tide_period_varid, 'long_name','tide angular period');
netcdf.putAtt(ncid, tide_period_varid, 'units','seconds');

% tide_Ephase
tide_Ephase_varid = netcdf.defVar(ncid,'tide_Ephase','float',[nobc_dimid,tidal_components_dimid]);
netcdf.putAtt(ncid, tide_Ephase_varid, 'long_name','tidal elevation phase angle');
netcdf.putAtt(ncid, tide_Ephase_varid, 'units','degrees, time of maximum elevation with respect to chosen time origin');

% tide_Eamp
tide_Eamp_varid = netcdf.defVar(ncid,'tide_Eamp','float',[nobc_dimid,tidal_components_dimid]);
netcdf.putAtt(ncid, tide_Eamp_varid, 'long_name','tidal elevation amplitude');
netcdf.putAtt(ncid, tide_Eamp_varid, 'units','meters');

%write global attributes
netcdf.putAtt(ncid,netcdf.getConstant('GLOBAL'),'type','FVCOM SPECTRAL ELEVATION FORCING FILE');
% netcdf.putAtt(ncid,netcdf.getConstant('GLOBAL'),'components','M2,S2,N2,K2,K1,P1,O1,Q1');

%end define mode
netcdf.endDef(ncid);

%put data in the output file
netcdf.putVar(ncid,time_origin_varid, time);
netcdf.putVar(ncid,tide_Eref_varid, eref);
netcdf.putVar(ncid,obc_nodes_varid, obc);
netcdf.putVar(ncid,tide_period_varid, period);
netcdf.putVar(ncid,tide_Ephase_varid, phase);
netcdf.putVar(ncid,tide_Eamp_varid, amplitude);


% close NC file
netcdf.close(ncid)
