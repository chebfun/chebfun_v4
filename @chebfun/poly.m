function out = poly(f,n)
% POLY	Polynomial coefficients.
% POLY(F) returns the polynomial coefficients of the first fun of F. 
% POLY(F,N) returns the polynomial coefficients of the Nth fun of F.
% For numerical work, the Chebyshev polynomial coefficients returned
% by CHEBPOLY are more useful.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

nfuns = f.nfuns;
if nargin == 1
    if nfuns>1
        warning('Chebfun has more than one fun. Only the polynomial coefficients of the first one are returned');
    end
    n = 1;
end

if n>nfuns
    error(['Chebfun only has ',num2str(nfuns),' funs'])
else

    a = f.ends(n); b = f.ends(n+1);
    x = chebfun(@(x) x,[a,b],length(f.funs(n))); % Chebyshev nodes
    
    % polyfit uses the Vandermonde matrix (results may be unreliable)
    out = polyfit(x.funs(n).vals,f.funs(n).vals,length(x)-1);

end

