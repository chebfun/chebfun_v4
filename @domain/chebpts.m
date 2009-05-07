function x = chebpts(d,n)
%CHEBPTS Chebyshev points in a domain.
% X = CHEBPTS(D,N) returns N Chebyshev points scaled to the domain D.

% Copyright 2009 by Toby Driscoll. See www.comlab.ox.ac.uk/chebfun.
 
x = chebpts(n);
ab = d.ends;
x = (x+1)/2*diff(ab) + ab(1);