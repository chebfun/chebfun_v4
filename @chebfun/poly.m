function out = poly(f,n)
% POLY	Polynomial coefficients.
% POLY(F) returns the polynomial coefficients of the first fun of F. 
% POLY(F,N) returns the polynomial coefficients of the Nth fun of F.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

nfuns = f.nfuns;
if nargin == 1
    if nfuns>1
        warning('Chebfun has more than one fun. Only the polynomial coefficients of the first one are returned');
    end
    a = f.ends(1); b = f.ends(2);
    out = scale(poly(f.funs(1)),a,b);
else
    if n>nfuns
        error(['Chebfun only has ',num2str(nfuns),' funs'])
    else
        a = f.ends(n); b = f.ends(n+1);
        out = scale(poly(f.funs(n)),a,b); 
    end
end

