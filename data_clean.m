%==========================================================================
% Remove the columns or rows that are full of NaN
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% 2022-06-15
%
% Updates:
%
%==========================================================================
function [id_keep, id_remove] = data_clean(varargin)


ndata = length(varargin);

% 1) Check if all the data have the same dimension
dims = size(varargin{1});
ndim = length(dims);
for i = 2 : ndata
    if ~all(dims==size(varargin{i}))
        error('The input matrix have different sizes.')
    end
end

% 2) Build the new data
for i = 1 : ndata
    cmd = ['data(' repmat(':,',1,ndim) 'i) = varargin{:};'];
    eval(cmd);
end

% 3) Checking which index could be deleted
for i = 1 : ndim
    id_remove{i} = [];
    id_keep{i} = [];
    for j = 1 : dims(i)
        
        cmd = ['tmp = data(' repmat(':,',1,i-1) 'j' repmat(',:',1,ndim-i) ');'];
        eval(cmd);

        if all(isnan(tmp(:)))
            id_remove{i} = [id_remove{i} j];
        else
            id_keep{i} = [id_keep{i} j];
        end

    end
end
