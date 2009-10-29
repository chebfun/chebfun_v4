function out = legpoly(f,n)
% LEGPOLY   Legendre polynomial coefficients.
% A = LEGPOLY(F) returns the coefficients such that
% F_1 = A(1) P_N(x) + ... + A(N) P_1(x) + A(N+1) P_0(x) where P_N(x) denotes 
% the N-th Legendre polynomial and F_1 denotes the first fun of chebfun F.
%
% A = LEGPOLY(F,I) returns the coefficients for the I-th fun.


% F_1 = A(1) T_N(x)+...+a(N) T_1(x)+A(N+1) T_0(x) where T_N(x) denotes the 
% N-th Chebyshev polynomial and F_1 denotes the first fun of chebfun F.
%
% A = CHEBPOLY(F,I) returns the coefficients for the I-th fun.


%
% There is also a LEGPOLY command in the chebfun trunk directory, which
% computes the chebfun corresponding to the Legendre polynomial P_n.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2009 by The Chebfun Team. 
 
if numel(f)>1, error('LEGPOLY does not handle chebfun quasi-matrices'), end
 
% Select fun!
if nargin == 1
    if f.nfuns>1
        warning(['Chebfun has more than one fun. Only the Chebyshev' ...
                 ' coefficients of the first one are returned.' ...
                 ' Use LEGPOLY(F,1) to suppress this warning.'])
    end
    out = legpoly(f.funs(1));
else
    if n>f.nfuns
        error(['Chebfun only has ',num2str(f.nfuns),' funs'])
    else
        out = legpoly(f.funs(n));
    end
end
