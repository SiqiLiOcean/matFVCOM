%==========================================================================
% Write the FVCOM sigma input file (ASCII)
%
% input  :
%   fout --- sigma path and name
%   
% 
% output :
%
% Siqi Li, SMAST
% 2022-12-27
%
% Updates:
%
%==========================================================================
function write_sigma(fout, kb, type, varargin)

varargin = read_varargin(varargin, {'hmin'}, {[]});
varargin = read_varargin(varargin, {'power'}, {[]});
varargin = read_varargin(varargin, {'DU'}, {[]});
varargin = read_varargin(varargin, {'DL'}, {[]});
varargin = read_varargin(varargin, {'KU'}, {[]});
varargin = read_varargin(varargin, {'KL'}, {[]});
varargin = read_varargin(varargin, {'ZKU'}, {[]});
varargin = read_varargin(varargin, {'ZKL'}, {[]});

type = upper(type);

fid = fopen(fout, 'w');
switch type
    case 'UNIFORM'
        fprintf(fid, '%s %d\n', 'NUMBER OF SIGMA LEVELS =', kb);
        fprintf(fid, '%s %s\n', 'SIGMA COORDINATE TYPE =', type);
    case 'GEOMETRIC'
        if isempty(power)
            error('UNIFORM required setting: \npower%s', '')
        end
        fprintf(fid, '%s %d\n', 'BUMBER OF SIGMA LEVELS =', kb);
        fprintf(fid, '%s %s\n', 'SIGMA COORDINATE TYPE =', type);
        fprintf(fid, '%s %f\n', 'SIGMA POWER =', power);
    case 'TANH'
        if isempty(DU) || isempty(DL)
            error('UNIFORM required setting: \nDU \nDL%s', '')
        end
        fprintf(fid, '%s %d\n', 'BUMBER OF SIGMA LEVELS =', kb);
        fprintf(fid, '%s %s\n', 'SIGMA COORDINATE TYPE =', type);
        fprintf(fid, '%s %f\n', 'DU =', DU);
        fprintf(fid, '%s %f\n', 'DL =', DL);
    case 'GENERALIZED'
        if isempty(DU) || isempty(DL) || isempty(hmin) || isempty(KU) || isempty(KL) || isempty(ZKU) || isempty(ZKL)
            error('UNIFORM required setting: \nDU \nDL \nhmin \nKU \nKL \nZKU \nZKL%s', '')
        end
        fprintf(fid, '%s %d\n', 'BUMBER OF SIGMA LEVELS =', kb);
        fprintf(fid, '%s %s\n', 'SIGMA COORDINATE TYPE =', type);
        fprintf(fid, '%s %f\n', 'DU =', DU);
        fprintf(fid, '%s %f\n', 'DL =', DL);
        fprintf(fid, '%s %f\n', 'MIN CONSTANT DEPTH =', hmin);
        fprintf(fid, '%s %d\n', 'KU =', KU);
        fprintf(fid, '%s %d\n', 'KL =', KL);
        format1 = ['%s' repmat(' %.1f',1,KU) '\n'];
        format2 = ['%s' repmat(' %.1f',1,KL) '\n'];
        fprintf(fid, format1, 'ZKU =', ZKU);
        fprintf(fid, format2, 'ZKL =', ZKL);
    otherwise
        error('UNKNOWN coordinate type. Select from:  \nUNIFORM, GEOMETRIC, TANH, or GENERALIZED')
end
fclose(fid);