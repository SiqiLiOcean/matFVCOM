%==========================================================================
% matFVCOM package
% Create a new FVCOM restart file from an existing one of a different grid.
%
% input  :
%   fin       --- source restart file
%   fgrid_in  --- source fvcom grid
%   fgrid_out --- destination fvcom grid
%   fout      --- output restart file
%   std       --- standard depth
%   *Ignore   --- Some variables are unneccessary to run FVCOM, I have set
%                 some and you can set more (in string).   {""}
%   *More variable can be set after all the settings in the format of 
%    interp_restart(...,'var1_name',var1_value,'var2_name',var2_value); 
%    Variables related with obc and lsf are highly recommended to set in
%    this way.
%
% output :
%   \
%
% Siqi Li, SMAST
% 2023-03-02
%
% Updates:
%
%==========================================================================
function interp_restart(fgrid_in, fgrid_out, fin, fout, std, varargin)

List_ignore = ["nprocs" "ML_Depth" "ML_Nsiglay" "xc" "yc" "lonc" "latc" "partition"];
List_grid = ["x" "y" "lon" "lat" "nv" "siglay" "siglev" "h"];
List_user = [];

% Ignore
varargin = read_varargin(varargin, {'Ignore'}, {[]});
List_ignore = [List_ignore Ignore];
% User
i = 1;
while length(varargin)>1
    name = varargin{i};
    value = varargin{i+1};
    eval([name ' = value;']);
    i = i+2;
    varargin(1:2) = [];
    List_user = [List_user convertCharsToStrings(name)];
end

varargin = read_varargin2(varargin, {'Overwrite'});

if ~isempty(Overwrite)
    if exist(fout, 'file') == 2
        delete(fout);
    end
else
    if exist(fout, 'file') == 2
        error('The output exists. Change another fout or use Overwrite.')
    end
end

% % Read input grid
% fgrid_in = f_load_grid(fin);



% Calculate the weights
disp('====Calculate weights')
disp('   for 2d (node x layer)')
w_node_siglay = interp_3d_calc_weight(fgrid_in.deplay, std, fgrid_out.deplay, ...
                                 'TRI', fgrid_in.x, fgrid_in.y, fgrid_in.nv, fgrid_out.x, fgrid_out.y, 'Extrap', fgrid_in.type);
disp('   for 2d (node x level)')
w_node_siglev = interp_3d_calc_weight(fgrid_in.deplev, std, fgrid_out.deplev, ...
                                 'TRI', fgrid_in.x, fgrid_in.y, fgrid_in.nv, fgrid_out.x, fgrid_out.y, 'Extrap', fgrid_in.type);
disp('   for 2d (cell x layer)')
w_cell_siglay = interp_3d_calc_weight(fgrid_in.deplayc, std, fgrid_out.deplayc, ...
                                 'TRI', fgrid_in.xc, fgrid_in.yc, fgrid_in.nv, fgrid_out.xc, fgrid_out.yc, 'Extrap', fgrid_in.type);
disp('   for 2d (cell x level)')
w_cell_siglev = interp_3d_calc_weight(fgrid_in.deplevc, std, fgrid_out.deplevc, ...
                                 'TRI', fgrid_in.xc, fgrid_in.yc, fgrid_in.nv, fgrid_out.xc, fgrid_out.yc, 'Extrap', fgrid_in.type);
disp('   for 1d (node)')
w_node = w_node_siglay.h;
disp('   for 1d (cell)')
w_cell = w_cell_siglay.h;


info = ncinfo(fin);
Dimensions = info.Dimensions;
variables = info.Variables;


% Copy global attributes
nc_copy_att(fin, [], fout, []);

% Define dimensions.
dimname = {Dimensions(:).Name};
dimlen = [Dimensions(:).Length];
for id = 1 : length(Dimensions)
    switch dimname{id}
        case 'node'
            nc_def_dim(fout, 'node', fgrid_out.node);
        case 'nele'
            nc_def_dim(fout, 'nele', fgrid_out.nele);
        case 'siglay'
            nc_def_dim(fout, 'siglay', fgrid_out.kbm1);
        case 'siglev'
            nc_def_dim(fout, 'siglev', fgrid_out.kb);
        case 'time'
            nc_def_dim(fout, 'time', 0);
        otherwise
            nc_def_dim(fout, dimname{id}, dimlen(id));
    end
end

% Define variables
for iv = 1 : length(variables)
    % Variable information
    varname = variables(iv).Name;
    vartype = variables(iv).Datatype;
    if ~isempty(variables(iv).Dimensions)
        vardims = {variables(iv).Dimensions.Name};
    else
        vardims = [];
    end
    % Check variables
    if ismember(varname, List_ignore)
        fprintf('%20s%s\n', varname, ' : ignored')
        continue
    end

    nc_def_var(fout, varname, vartype, vardims);
    nc_copy_att(fin, varname, fout, varname);

    if ismember(varname, List_user)
        fprintf('%20s%s\n', varname, ' : User defined')
        cmd = ['nc_put_var(fout, ''' varname ''', ' varname ');'];
        eval(cmd);
    elseif ismember(varname, List_grid)
        fprintf('%20s%s\n', varname, ' : Grid variables')
        switch(varname)
            case 'x'
                nc_put_var(fout, varname, fgrid_out.x);
            case 'y'
                nc_put_var(fout, varname, fgrid_out.y);
            case 'lon'
                nc_put_var(fout, varname, fgrid_out.LON);
            case 'lat'
                nc_put_var(fout, varname, fgrid_out.LAT);
            case 'nv'
                nc_put_var(fout, varname, fgrid_out.nv);
            case 'siglay'
                nc_put_var(fout, varname, fgrid_out.siglay);
            case 'siglev'
                nc_put_var(fout, varname, fgrid_out.siglev);
            case 'h'
                nc_put_var(fout, varname, fgrid_out.h);
            otherwise
                error(['Unknown vairable name for grid: ' varname])
        end
    else
        data1 = nc_get_var(fin, varname);
        if strcmp(vartype, 'int32')
            data1 = double(data1);
        end
        if ismember('node', vardims)
            if ismember('siglay', vardims)
                fprintf('%20s%s\n', varname, ' : node x siglay')
                data2 = interp_3d_via_weight(data1, w_node_siglay);
            elseif ismember('siglev', vardims)
                fprintf('%20s%s\n', varname, ' : node x siglev')
                data2 = interp_3d_via_weight(data1, w_node_siglev);
            else
                fprintf('%20s%s\n', varname, ' : node')
                data2 = interp_2d_via_weight(data1, w_node);
            end
        elseif ismember('nele', vardims)
            if ismember('siglay', vardims)
                fprintf('%20s%s\n', varname, ' : nele x siglay')
                data2 = interp_3d_via_weight(data1, w_cell_siglay);
            elseif ismember('siglev', vardims)
                fprintf('%20s%s\n', varname, ' : nele x siglev')
                data2 = interp_3d_via_weight(data1, w_cell_siglev);
            else
                fprintf('%20s%s\n', varname, ' : nele')
                data2 = interp_2d_via_weight(data1, w_cell);
            end 
        else
            fprintf('%20s%s\n', varname, ' : Kept unchanged')
            data2 = data1;
        end
        if strcmp(vartype, 'int32')
            data2 = int32(data2);
        end
        nc_put_var(fout, varname, data2);
    end
end
