function out = chebpoly(f,n)
% CHEBPOLY   Chebyshev polynomial coefficients.
% A = CHEBPOLY(F) returns the coefficients such that
% F_1 = A(1) T_N(x) + ... + A(N) T_1(x) + A(N+1) T_0(x) where T_N(x) denotes 
% the N-th Chebyshev polynomial and F_1 denotes the first fun of chebfun F.
%
% A = CHEBPOLY(F,I) returns the coefficients for the I-th fun.
%
% There is also a CHEBPOLY command in the chebfun trunk directory, which
% computes the chebfun corresponding to the Chebyshev polynomial T_n.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 
 
if numel(f)>1, error('CHEBFUN:chebpoly:quasi','CHEBPOLY does not handle chebfun quasi-matrices'), end

if nargin == 1
    if f.nfuns>1
        warning('CHEBFUN:chebpoly',['Chebfun has more than one fun. Only the Chebyshev' ...
                 ' coefficients of the first one are returned.' ...
                 ' Use CHEBPOLY(F,1) to suppress this warning.'])
    end
    out = chebpoly(f.funs(1)).';
else
    if n>f.nfuns
        error('CHEBFUN:chebpoly:nfuns',['Chebfun only has ',num2str(f.nfuns),' funs'])
    else
        out = chebpoly(f.funs(n)).';
    end
end
