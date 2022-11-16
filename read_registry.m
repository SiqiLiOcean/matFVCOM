%==========================================================================
% Read WRF registry file(s).
%
% input  :
%   freg --- input register file
%
% output :
%   R --- register information
%   C --- the whole lines.
% 
% Siqi Li, SMAST
% yyyy-mm-dd
%
% Updates:
%
%==========================================================================
function [R, C] = read_registry(freg)

C = read_registry1(freg);
    
% dimspec
% Describes dimensions that are used to define arrays in the model
Tf = startsWith(C, "dimspec", 'IgnoreCase', true);

% state
% Describes state variables and arrays in the domain structure
Tf = find(startsWith(C, "state", 'IgnoreCase', true));
for i = 1: length(Tf)
    C2 = textscan(C{Tf(i)}, '%s', 11);
    C2 = C2{1};
    C2(end+1:11) = {''};
    R.state(i).type    = C2{2};  % The type of the state variable or array
                                 % real, double, integer, logical,
                                 % character, or derived
    
    R.state(i).sym     = C2{3};  % The symbolic name of the variable or array
    
    R.state(i).dims    = C2{4};  % A string denoting the dimensionality of 
                                 % array or a hyphen (-)
                                 
    R.state(i).use     = C2{5};  % A string denoting association with a 
                                 % solver or 4D scalar array, or a hyphen
                                 
    R.state(i).numtlev = C2{6};  % An integer indicating the number of time 
                                 % levels (for arrays) or hyphen (for variables)
                                 
    R.state(i).stagger = C2{7};  % String indicating staggered dimensions 
                                 % of variable (X, Y, Z, or hyphen)
                                 
    R.state(i).io      = C2{8};  % String indicating whether and how the 
                                 % variable is subject to various I/O and 
                                 % Nesting
                                 
    R.state(i).dname   = C2{9};  % Metadata name for the variable
          
    R.state(i).units   = C2{10}; % Metadata units of the variable
    
    R.state(i).descrip = C2{11}; % Metadata description of the variable
    
    R.state(i).line    = Tf(i);
end
    

% i1
% Describes local variables and arrays in solve
Tf = startsWith(C, "i1", 'IgnoreCase', true);

% typedef
% Describes derived types that are subtypes of the domain sturcture
Tf = startsWith(C, "typedef", 'IgnoreCase', true);

% rconfig
% Describes a configuration (e.g. namelist) variable or array 
Tf = find(startsWith(C, "rconfig", 'IgnoreCase', true));
for i = 1: length(Tf)
    C2 = textscan(C{Tf(i)}, '%s', 10);
    C2 = C2{1};
    C2(end+1:10) = {''};
    R.rconfig(i).type    = C2{2};  % The type of the state variable or array
                                   % real, double, integer, logical,
                                   % character, or derived
    
    R.rconfig(i).sym     = C2{3};  % The symbolic name of the variable or array
    
    R.rconfig(i).how_set = C2{4};  % Indicates how the variable is set: 
                                   % e.g. namelist or derived, and if
                                   % namelist, which block of the namelist
                                   % it is set in
                                 
    R.rconfig(i).nentries= C2{5};  % specifies the dimensionality of the 
                                   %namelist variable or array. If 1 (one) 
                                   % it is a variable and applies to all 
                                   % domains; otherwise specify max_domains
                                   % (which is an integer parameter defined 
                                   % in module_driver_constants.F).
                                 
    R.rconfig(i).default = C2{6};  % the default value of the variable to 
                                   % be used if none is specified in the 
                                   % namelist; hyphen (-) for no default.
                                 
    R.rconfig(i).io      = C2{7};  % String indicating whether and how the 
                                   % variable is subject to various I/O and 
                                   % Nesting
                                 
    R.rconfig(i).dname   = C2{8};  % Metadata name for the variable
    
    R.rconfig(i).descrip = C2{9};  % Metadata description of the variable
          
    R.rconfig(i).units   = C2{10}; % Metadata units of the variable
    
    R.rconfig(i).line    = Tf(i);
end

% package
% Describes attributes of a package (e.g. physics)
Tf = startsWith(C, "package", 'IgnoreCase', true);

% halo
% Describes halo update interprocessor communications
Tf = startsWith(C, "halo", 'IgnoreCase', true);

% period 
% Describes communications for periodic boundary updates
Tf = startsWith(C, "period", 'IgnoreCase', true);

% xpose
% Describes communications for parallel matrix transposes
Tf = startsWith(C, "xpose", 'IgnoreCase', true);

end


function C = read_registry1(freg0)


dir0 = dir(freg0);
path0 = dir0.folder;


fid = fopen(freg0);
C0 = textscan(fid, '%s', 'Delimiter', '\n');
C0 = strtrim(C0{1});
fclose(fid);

% Remove the lines starting with #
Tf = startsWith(C0, "#");
C0 = C0(~Tf);

% Remove the lines starting with ifdef
Tf = startsWith(C0, "ifdef");
C0 = C0(~Tf);

% Remove the lines starting with #
Tf = startsWith(C0, "endif");
C0 = C0(~Tf);

% Combine the lines saperated by \
Tf = find(endsWith(C0, "\"));
if ~isempty(Tf)
    for i = Tf(:)'
        line1 = C0{i};
        line2 = C0{i+1};
        C0{i} = [line1(1:end-1) ' ' line2];
    end
end
C0(Tf+1) = [];
    

% Remove the empty lines
Tf = strlength(C0);
C0 = C0(Tf>0);

% include
% Similar to a CPP # include file
Tf = startsWith(C0, "include", 'IgnoreCase', true);
C = [];
for i = 1:length(Tf)
    if Tf(i)
        C_include = textscan(C0{i}, '%s', 2);
        C_include = C_include{1};
    
        freg1 = [path0 '\' C_include{2}];
        C1 = read_registry1(freg1);
        C =[C; C1];
    else
        C = [C; C0(i)];
    end
end


end
