%==========================================================================
%
%
% input  :
%   url      --- the original url
%   outdir   --- the output directory
%   str1     ---
%   str2     ---
%   'Update' --- only download the new directories and files
%   
%
% output :
%
% Siqi Li, SMAST
% yyyy-mm-dd
%
% Updates:
%
%==========================================================================
function url_download_files(url, outdir, str1, str2, varargin)

varargin = read_varargin2(varargin, {'Update'});


% Create new directory
if exist(outdir, 'dir')==7
else
    disp(outdir)
    mkdir(outdir);
end

% Read the webpage
[txt, status] = urlread(url);
if (status<0)
    return
end
% txt = webread(url);


% Get the file list
% url
% str1
% str2
fname = txt_middle(txt, str1, str2);

% Remove the 'Parent Directory'
fname(contains(fname, 'Parent Directory')) = [];


for ifile = 1 : length(fname)

    if strcmp(fname{ifile}(end), '/')
        outdir_new = [outdir '/' fname{ifile}];
        url_new = [url '/' fname{ifile}];
        url_download_files(url_new, outdir_new, str1, str2, Update);
    else
        existed_files = dir(outdir);
        if ~isempty(Update) && contains([existed_files(:).name], fname{ifile})
        else
            url_new = [url '/' fname{ifile}];
            file = [outdir '/' fname{ifile}];
            file = strrep(file, ' ', '_');

            disp(file)

            % Save the file
            websave(convertCharsToStrings(file), url_new);
        end
    end

end