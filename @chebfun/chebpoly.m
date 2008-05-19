function out = chebpoly(f,n)
% CHEBPOLY   Chebyshev polynomial coefficients.
% A = CHEBPOLY(F) returns the coefficients such that
% F_1 = a_N T_N(x)+...+a_1 T_1(x)+a_0 T_0(x) where T_N(x) denotes the N-th
% Chebyshev polynomial and F_1 denotes the first fun of chebfun F.
%
% A = CHEBPOLY(F,i) returns the coefficients for the i-th fun.
 
% Copyright 2002-2008 by The Chebfun Team. See www.chebfun.org.

if numel(f)>1, error('CHEBPOLY does not handle chebfun quasi-matrices'), end

if nargin == 1
    if f.nfuns>1
        warning(['Chebfun has more than one fun. Only the Chebyshev' ...
                 ' coefficients of the first one are returned.' ...
                 ' Use CHEBPOLY(F,1) to suppress this warning.'])
    end
    out = chebpoly(f.funs(1));
else
    if n>f.nfuns
        error(['Chebfun only has ',num2str(f.nfuns),' funs'])
    else
        out = chebpoly(f.funs(n));
    end
end
