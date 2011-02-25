function g = real(g)
% REAL	Complex real part
% REAL(G) is the real part of G.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

gvals = real(g.vals);
if all(gvals == 0), 
    g.vals = 0; g.n = 1; g.scl.v = 0;
else
    g.vals = gvals;
    g = simplify(g);
end