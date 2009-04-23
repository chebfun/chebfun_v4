function f = chebpoly(n,d)
% CHEBPOLY   Chebyshev polynomial of degree n.
% F = CHEBPOLY(N) returns the chebfun corresponding to the Chebyshev
% polynomial T_n(x) on [-1,1].  F = CHEBPOLY(N,d), where d is an interval
% or a domain, gives the same result scaled accordingly.
%
% See also chebfun/chebpoly.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 
 
if nargin == 1
    f = chebfun((-1).^(n:-1:0));
else
    f = chebfun((-1).^(n:-1:0),d);
end
