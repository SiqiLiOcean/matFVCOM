%==========================================================================
% matFVCOM package
%   write FVCOM river nml file
%
% input  :
%   fnml
%   river_name
%   river_file
%   id
%   distribution
%
% output :
%
% Siqi Li, SMAST
% 2023-09-19
%
% Updates:
%
%==========================================================================
function write_nml_river(fnml, river_name, river_file, id, distribution, varargin)

varargin = read_varargin2(varargin, {'Append'});

nml.NML_RIVER.RIVER_NAME = river_name;
nml.NML_RIVER.RIVER_file = river_file;
nml.NML_RIVER.RIVER_GRID_LOCATION = id;
nml.NML_RIVER.RIVER_VERTICAL_DISTRIBUTION = distribution;

write_nml(fnml, nml, 'EndComma', 'WithQuote', Append);
