%==========================================================================
% matFVCOM package
% Read weights in ESMF style
%
% input  :
%   fweight --- ESMF interpolating weights
%   **Extrap  --- invoke extrapolation
% 
% output :
%   weight  --- interpolating weights
%
% Siqi Li, SMAST
% 2023-03-01
%
% Updates:
%
%==========================================================================
function weight = esmf_read_weight(fweight, varargin)

varargin = read_varargin2(varargin, {'Extrap'});

info = ncinfo(fweight);
k = find(contains({info.Dimensions.Name}, 'n_a'));
weight.n_a = info.Dimensions(k).Length;
k = find(contains({info.Dimensions.Name}, 'n_b'));
weight.n_b = info.Dimensions(k).Length;
k = find(contains({info.Dimensions.Name}, 'n_s'));
weight.n_s = info.Dimensions(k).Length;



weight.col = ncread(fweight, 'col');
weight.row = ncread(fweight, 'row');
weight.S = ncread(fweight, 'S');
weight.frac_b = ncread(fweight, 'frac_b');
in = ismember(1:weight.n_b, weight.row);
weight.in = find(in);
weight.out = find(~in);


if ~isempty(Extrap)
    xc_a = ncread(fweight, 'xc_a');
    yc_a = ncread(fweight, 'yc_a');
    xc_b = ncread(fweight, 'xc_b');
    yc_b = ncread(fweight, 'yc_b');
    weight.out_id = ksearch([xc_a yc_a], [xc_b(weight.out) yc_b(weight.out)]);
end
