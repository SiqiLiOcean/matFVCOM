function fun_dir = fundir(fun_name)

fun_dir = which(fun_name);

% k = strfind(fun_dir, ("/"|"\"));

if contains(computer, 'WIN')
    k = strfind(fun_dir, '\');
else
    k = strfind(fun_dir, '/');
end

fun_dir = fun_dir(1:k(end));

