function x = chebpts(d,n)
%CHEBPTS  Return Chebyshev interpolation points in a domain.
% CHEBPTS(D,N) returns a vector of N Chebyshev nodes in the domain D. The
% points are ordered from left to right and include the endpoints of the
% domain.
%
% See also domain/linspace.

% Copyright 2009 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

x = chebpts(n);
ab = d.ends;
x = (x+1)/2*(ab(end)-ab(1)) + ab(1);