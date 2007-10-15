function F = recursiveauto(op,ends,n)
% This was the recursive auto!
if diff(ends)<1e-8, 
    F = []; 
    return; 
end;

if isa(op,'double')|(isa(op,'char') & ~isempty(str2num(op)))
    f = fun(op,n); % make a fun from a constant or from a data string
    F = chebfun(f,ends);
elseif isa(op,'char')| isa(op,'function_handle')| isa(op,'inline')
    % make a fun from a string or from a function handle
    if isa(op,'char'), op = inline(op); end 
    [f,happy] = grow(op,ends);
    if happy
        F = chebfun(f,ends);
    else
        mdpt = mean(ends);
        F1 = auto(op,[ends(1) mdpt]);
        F2 = auto(op,[mdpt ends(2)]);
        F = [F1;F2];
    end
end