function F = power(f,b)
% .^	Chebfun power
% F.^G returns a chebfun F to the scalar power G or a scalar F to the
% chebfun power G. The effect of impulses has been ignored.

% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
if (isa(f,'chebfun') & isa(b,'chebfun'))
  error('Cannot raise a chebfun to the power of a chebfun.');
end

if isa(f,'chebfun') & b == 0
    F = chebfun(1,[f.ends(1) f.ends(end)]);
elseif isa(f,'chebfun')
    F = f;
    nfuns = length(f.funs);
    for i = 1:nfuns
        F.funs{i} = (F.funs{i}).^b;
    end
else
    F = b;
    nfuns = length(b.funs);
    for i = 1:nfuns
        F.funs{i}  = f.^(F.funs{i});
    end
end
