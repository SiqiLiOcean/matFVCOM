%==========================================================================
% matFVCOM package
%   Merge the nesting files. 
%
% input  :
%   fin   --- input nesting files
%   fout  --- output nesting file
%   'Geo' --- for spherical coordinate; if not set, the coordinate is xy
%   'dt'  --- output time interval; if not set, dt will use the one in the
%             first nesting input.
% 
% output :
%
% Siqi Li, SMAST
% 2023-06-28
%
% Updates:
%
%==========================================================================
function merge_nesting(fin, fout, varargin)

varargin = read_varargin2(varargin, {'Geo'});
if ~isempty(Geo)
    varname1 = 'lonc';
    varname2 = 'latc';
else
    varname1 = 'xc';
    varname2 = 'yc';
end
nf = length(fin);

%---------------------Read the grid----------------------------------------
f = f_load_grid(fin{1});

time0 = [];
t2 = -999;
for i = 1 : nf
    time = f_load_time(fin{i});
    it = find(time>t2);
    if isempty(it)
        for j = 1 : nf
            t = f_load_time(fin{i});
            disp([fin{j} ': ' datestr(t(1), 'yyyy-mm-ddTHH:MM') ' - ' datestr(t(end), 'yyyy-mm-ddTHH:MM')])
        end
        error('The file order is not right.')
    end
    it1(i) = it(1);
    it2(i) = it(end);
    t2 = time(it2(i));
    nt(i) = length(it);

    time0 = [time0; time(it1(i):it2(i))];
end
t1 = time0(1);
t2 = time0(end);
dt0 = double(int32((time0(2)-time0(1)) * 24 * 3600));

varargin = read_varargin(varargin, {'dt'}, {dt0});
time = t1 : dt/3600/24 : t2;

%---------------------Read the data----------------------------------------
if any(contains({ncinfo(fin{1}).Variables.Name}, 'hyw'))
    have_hyw = 1;
else
    have_hyw = 0;
end

xc1 = ncread(fin{1}, varname1);
yc1 = ncread(fin{1}, varname2);
zeta0 = nan(f.node, sum(nt));
ua0 = nan(f.nele, sum(nt));
va0 = nan(f.nele, sum(nt));
u0 = nan(f.nele, f.kbm1, sum(nt));
v0 = nan(f.nele, f.kbm1, sum(nt));
temp0 = nan(f.node, f.kbm1, sum(nt));
salinity0 = nan(f.node, f.kbm1, sum(nt));
if have_hyw
    hyw0 = nan(f.node, f.kb, sum(nt));
end
disp('----Read nesting data:')
for i = 1 : nf
    disp(['    ' fin{i}])
    xc2 = ncread(fin{i}, varname1);
    yc2 = ncread(fin{i}, varname2);
    idc = knnsearch([xc1 yc1], [xc2 yc2]);
    zeta0(:,sum(nt(1:i-1))+1:sum(nt(1:i))) = ncread(fin{i}, 'zeta', [1 it1(i)], [Inf Inf]);
    ua0(idc,sum(nt(1:i-1))+1:sum(nt(1:i))) = ncread(fin{i}, 'ua', [1 it1(i)], [Inf Inf]);
    va0(idc,sum(nt(1:i-1))+1:sum(nt(1:i))) = ncread(fin{i}, 'va', [1 it1(i)], [Inf Inf]);
    u0(idc,:,sum(nt(1:i-1))+1:sum(nt(1:i))) = ncread(fin{i}, 'u', [1 1 it1(i)], [Inf Inf Inf]);
    v0(idc,:,sum(nt(1:i-1))+1:sum(nt(1:i))) = ncread(fin{i}, 'v', [1 1 it1(i)], [Inf Inf Inf]);
    temp0(:,:,sum(nt(1:i-1))+1:sum(nt(1:i))) = ncread(fin{i}, 'temp', [1 1 it1(i)], [Inf Inf Inf]);
    salinity0(:,:,sum(nt(1:i-1))+1:sum(nt(1:i))) = ncread(fin{i}, 'salinity', [1 1 it1(i)], [Inf Inf Inf]);
    if have_hyw
        hyw0(:,:,sum(nt(1:i-1))+1:sum(nt(1:i))) = ncread(fin{i}, 'hyw', [1 1 it1(i)], [Inf Inf Inf]);
    end
end

%---------------------Interpolate on time----------------------------------
wt = interp_time_calc_weight(time0, time);
zeta = interp_time_via_weight(zeta0, wt);
ua = interp_time_via_weight(ua0, wt);
va = interp_time_via_weight(va0, wt);
u = interp_time_via_weight(u0, wt);
v = interp_time_via_weight(v0, wt);
temp = interp_time_via_weight(temp0, wt);
salinity = interp_time_via_weight(salinity0, wt);
if have_hyw
    hyw = interp_time_via_weight(hyw0, wt);
end


%---------------------Write nesting output---------------------------------
if have_hyw
    write_nesting(fout, f, 'Time', time, ...
                       'Zeta', zeta, ...
                       'Temperature', temp, ...
                       'Salinity', salinity, ...
                       'U', u, ...
                       'V', v, ...
                       'Ua', ua, ...
                       'Va', va, ...
                       'Hyw', hyw);
else
    write_nesting(fout, f, 'Time', time, ...
                       'Zeta', zeta, ...
                       'Temperature', temp, ...
                       'Salinity', salinity, ...
                       'U', u, ...
                       'V', v, ...
                       'Ua', ua, ...
                       'Va', va);
end
