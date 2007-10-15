function F = uminus(f)
% -	Unary minus
% -F negates the chebfun F.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
F = f;
nfuns = length(f.funs);
for i = 1:nfuns
    F.funs{i} = -(F.funs{i});
end
F.imps = -F.imps;