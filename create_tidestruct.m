%==========================================================================
% Create tidestruct for t_predic
%
% input  :
%   tide --- a struct with tide constituents.
%            name
%            amplicutde (m)
%            phase (degree)
% 
% output :
%   tidestruct --- tide structure for t_predic
%                  name    n*4 char
%                  freq    n*1 double
%                  tidecon n*4 double
%                  type    'nodal'
%
% Siqi Li, SMAST
% 2022-09-13
%
% Updates:
%
%==========================================================================
function tidestruct = create_tidestruct(tide)

load('t_constituents', 'const');

const_list = cellstr(const.name);

j = 0;
for i = 1 : length(tide)
    k = find(strcmp(const_list,  tide(i).name));
    if ~isempty(k)
        j = j + 1;
        id1(j) = k;  % For const
        id2(j) = i;  % For tide
    else
        disp([char(tide(i).name) ' is not included.'])
    end
end

tidestruct.name = const.name(id1,:);
tidestruct.freq = const.freq(id1);
amp = [tide(id2).amplitude]';
pha = [tide(id2).phase]';
tidestruct.tidecon = [amp amp*0 pha pha*0];
tidestruct.type = 'nodal';
