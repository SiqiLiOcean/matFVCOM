%==========================================================================
% Create the 'tidestruc' structure variable for t_tide
%
% input  :
%   name      : tide constituent name (cell or char)
%   amplitude : constituent amplitude
%   phase     : constituent phase
% 
% output :
%   tidestruc : for t_predic
%
% Usage  :
%   tide_zeta = create_tidestruc(name, amplitude, phase);
%     tide_uv = create_tidestruc(name, fmaj, fmin, finc, pha);
%
% Siqi Li, SMAST
% 2021-09-30
%
% Updates:
%
%==========================================================================
function tidestruc = create_tidestruc(name, varargin)

n = length(varargin);
switch n
    case 2
        amp = varargin{1};
        pha = varargin{2};
    case 4
        fmaj = varargin{1};
        fmin = varargin{2};
        finc = varargin{3};
        pha = varargin{4};
    otherwise
        disp('Usage: ')
        disp('  elevation --- create_tidestruc(name, amp, pha)')
        disp('     vector --- create_tidestruc(name, fmaj, fmin, finc, pha)')
        error('')
end

load('t_constituents', 'const');
conList = upper(const.name);
% name0 = [
%         'MM  ';'MSF ';'ALP1';'2Q1 ';'Q1  '; ...
%         'O1  ';'NO1 ';'P1  ';'K1  ';'J1  '; ...
%         'OO1 ';'UPS1';'EPS2';'MU2 ';'N2  '; ...
%         'M2  ';'L2  ';'S2  ';'K2  ';'ETA2'; ...
%         'MO3 ';'M3  ';'MK3 ';'SK3 ';'MN4 '; ...
%         'M4  ';'SN4 ';'MS4 ';'S4  ';'2MK5'; ...
%         '2SK5';'2MN6';'M6  ';'2MS6';'2SM6'; ...
%         '3MK7';'M8  ';'M10 ';
%        ];
% frequency0 = [
%       0.00151215194764224;0.00282193266945103;0.0343965698259650;0.0357063505477738;0.0372185024954161;
%       0.03873065444305830;0.04026859427318180;0.0415525871125093;0.0417807462208240;0.0432928981684663;
%       0.04483083799858980;0.04634298994623200;0.0761773160467890;0.0776894679944313;0.0789992487162401;
%       0.08051140066388230;0.08202355261152450;0.0833333333333333;0.0835614924416480;0.0850736443892903;
%       0.11924205510694100;0.12076710099582300;0.1222921468847060;0.1251140795541570;0.1595106493801220;
%       0.16102280132776500;0.16233258204957300;0.1638447339972160;0.1666666666666670;0.2028035475485890;
%       0.20844741288749100;0.24002205004400500;0.2415342019916470;0.2443561346610980;0.2471780673305490;
%       0.28331494821247100;0.32204560265552900;0.4025570033194120;
%       ];
if ischar(name)
    name = cellstr(name);
end
name = upper(name);
  

  
  for i = 1 : length(name)
      k = find(ismember(conList, name{i}, 'rows'));
      if isempty(k)
          error(['Unfound tide constituent name: ' name{i}])
      end
      
      %       tidestruc.name(i,1:34) = strjust(sprintf('%4s', name{i}), 'left');
      tidestruc.name(i,1:4) = pad(conList(k,:), 4);
      tidestruc.freq(i,1) = const.freq(k);
      switch n
          case 2
              tidestruc.tidecon(i,1:4) = [amp(i) 0 pha(i) 0];
          case 4
              tidestruc.tidecon(i,1:8) = [fmaj(i) 0 fmin(i) 0 finc(i) 0 pha(i) 0];
      end
  end
  
%   tidestruc.type = 'nodal';
  
  
end