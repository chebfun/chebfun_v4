function F = mrdivide(f,g)
% /	Right scalar divide
% F/C divides the chebfun F by a scalar C.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
if (isempty(f)), 
    F=chebfun;
else
    if (isa(g,'double'))
        F=f;
        nfuns = length(f.funs);
        for i = 1:nfuns
            F.funs{i} = F.funs{i}/g;
        end
        F.imps = F.imps./g;
    else
        error('Use ./ to divide two chebfuns.');
    end
end