%==========================================================================
% matFVCOM package
%   Call VDatum to convert vertical datum.
%   This function will call the NOAA VDatum API, and support input data in 
%   array. See more details at:
%   https://vdatum.noaa.gov/docs/services.html
%
% input  :
%   s_v_frame --- input vertical datum
%   t_v_frame --- output vertical datum
%   x1  --- input x coordinate (degree)
%   y1  --- input y coordinate (degree)
%   z1  --- input height (m) (optional)
% 
% output :
%   z2  --- output height (m) or delta height if z1 is missing
%
% Siqi Li, SMAST
% 2023-04-14
%
% Updates:
%
%==========================================================================
function z2 = vdatum(s_v_frame, t_v_frame, x1, y1, z1, varargin)

varargin = read_varargin(varargin, {'s_h_frame'}, {'NAD83_2011'});


% x1 = -75.46803;
% y1 = 35.602986;
% z1 = 12.33;
% s_v_frame = 'NAVD88';
% t_v_frame = 'MLLW';

n = length(x1(:));

if ~exist('z1', 'var')
    z1 = 0 * x1;
end

z2 = nan(size(z1));
for i = 1 : n

    url = ['https://vdatum.noaa.gov/vdatumweb/api/convert' ...
            '?s_x=' num2str(x1(i)) ...
            '&s_y=' num2str(y1(i)) ...
            '&s_z=' num2str(z1(i)) ...
            '&s_h_frame=' s_h_frame ...
            '&s_v_frame=' s_v_frame ...
            '&s_v_unit=m' ...
            '&t_v_frame=' t_v_frame ...
            '&t_v_unit=m']
    data = webread(url);
    if isfield(data, 'errorCode')
        error([num2str(data.errorCode) ': ' data.message])
    end
    z2(i) = str2double(data.t_z);
    disp(['(' num2str(x1(i)) ',' num2str(y1(i)) ') : ' num2str(z1(i)) ' --> ' num2str(z2(i))])
end

