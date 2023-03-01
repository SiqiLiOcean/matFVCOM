%==========================================================================
% matFVCOM package
% Calculate interpolating weights in ESMF style
%
% input  :
%   fsrc        --- source grid file
%   fdst        --- destination grid file
%   fweight     --- output weight file
%   *ESMFMKFILE --- ESMF MK file path        {getenv('ESMFMKFILE')}
%   *exe        --- ESMF_RegridWeightGen path   {''}
%                   if exe is empty, then exe will be found from ESMFMKFILE
%   *Method     --- interpolating method
%                   'nearest_stod': interpolate data by finding the nearest 
%                                   point on the source grid with the same 
%                                   sign (positive or negative) as the 
%                                   destination point.
%                   'nearest_id': interpolate data by finding the nearest 
%                                 point on the source grid.
%                   'patch': interpolate data using a patch-based method 
%                            that uses a local weighted average of the 
%                            source data.
%                   'bilinear': interpolate data using a linear 
%                               interpolation method that takes into 
%                               account the four nearest points on the 
%                               source grid.
%                   'conservative': interpolate data using a conservative 
%                                   interpolation method that conserves the 
%                                   total amount of data during the 
%                                   regridding process.
%                   {'bilinear'}
%   *Extrap     --- extrapolating method
%                   'none': ignore any data that falls outside of the 
%                           source grid domain.
%                   'neareststod': extrapolate data by finding the nearest 
%                                   point on the source grid
%                   'nearestidavg': extrapolate data by finding the nearest 
%                                   point on the source grid and taking the 
%                                   average of the values at that point and 
%                                   its eight neighbors.
%                   float: extrapolate data using a constant value 
%                          specified by the '--extrap_val' option.
%                   {'none'}
%   *Src_loc    --- location used to do the regridding in source grid
%                   'corner' or 'center', only for UGRID or ESMF.
%                   {'corner'}
%   *Dst_loc    --- location used to do the regridding in destination grid
%                   'corner' or 'center', only for UGRID or ESMF.
%                   {'corner'}
%
% output :
%
% Siqi Li, SMAST
% 2023-02-28
%
% Updates:
%
%==========================================================================
function status = esmf_regrid_weight(fsrc, fdst, fweight, varargin)

varargin = read_varargin(varargin, {'ESMFMKFILE'}, {getenv('ESMFMKFILE')});
varargin = read_varargin(varargin, {'exe'}, {''});
varargin = read_varargin(varargin, {'Method'}, {'bilinear'});
varargin = read_varargin(varargin, {'Extrap'}, {'none'});
varargin = read_varargin(varargin, {'Src_loc'}, {'corner'});
varargin = read_varargin(varargin, {'Dst_loc'}, {'corner'});


if isempty(exe)

    if isempty(ESMFMKFILE)
        error('Set ESMFMKFILE first')
    end

    % Get the ESMF_regridWeightGen path from ESMFMKFILE
    exe = '';
    i =0 ;
    fid = fopen(ESMFMKFILE, 'r');
    while ~feof(fid)
        i = i + 1;
        line = fgetl(fid);
        k = strfind(line, '#');
        if ~isempty(k)
            line(k(1):end) = [];
        end
        if contains(line, 'ESMF_APPSDIR')
            k = strfind(line, '=');
            exe = [strtrim(line(k+1:end)) '/ESMF_regridWeightGen'];
            break
        end
    end
    fclose(fid);

    if isempty(exe)
        error('ESMF_regridWeightGen is not set properly.')
    end
end

% Check the file type
type_src = ncreadatt(fsrc, '/', 'type');
type_dst = ncreadatt(fdst, '/', 'type');
if all(~contains(["UGRID" "ESMF" "SCRIP" "GRIDSPEC"], type_src))
    error(['Unknown source file type: ' type_src])
end
if all(~contains(["UGRID" "ESMF" "SCRIP" "GRIDSPEC"], type_dst))
    error(['Unknown destination file type: ' type_dst])
end


% Run the command
cmd = exe;
cmd = [cmd ' --ignore_unmapped'];        % ignore the unmapped destination points.
cmd = [cmd ' --method ' Method];         % interp method
if isnumeric(Extrap)                     % extrap method
    cmd = [cmd ' --extrap_method ' 'constant' ' --extrap_val ' num2str(Extrap)];         
else
    cmd = [cmd ' --extrap_method ' Extrap];       
end
% cmd = [cmd ' --src_type ' type_src];     % source grid file type
cmd = [cmd ' -s ' fsrc];                 % source grid file
cmd = [cmd ' --src_loc ' Src_loc];       % source grid file
% cmd = [cmd ' --dst_type ' type_dst];     % destination grid file type
cmd = [cmd ' -d ' fdst];                 % destination grid file
cmd = [cmd ' --dst_loc ' Dst_loc];       % source grid file
cmd = [cmd ' --weight ' fweight];        % weight file
cmd = [cmd ' --no_log'];                 % turn off ESMF log
% Add src_meshname or dst_meshname in the future

% Create the weight file
tic;
disp(cmd);
status = system(cmd);
t = toc;
disp(['ESMF_regridWeightGen: ' num2str(t/60) ' min.'])
