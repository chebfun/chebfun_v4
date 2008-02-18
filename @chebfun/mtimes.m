function F = mtimes(f,g)
% *	Scalar multiplication
% F*G multiplies a chebfun by a scalar.

% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
if (isa(f,'chebfun') & isa(g,'chebfun'))
  error('Use .* to multiply two chebfuns.');
end
if isa(f,'chebfun')
    F = f;
    nfuns = length(f.funs);
    for i = 1:nfuns
        F.funs{i} = g*(F.funs{i});
    end
    F.imps = g*F.imps;
else
    F = g;
    nfuns = length(g.funs);
    for i = 1:nfuns
        F.funs{i}  = f*(F.funs{i});
    end
    F.imps = f*F.imps;
end
