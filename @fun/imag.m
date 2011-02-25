function g = imag(g)
% IMAG	Complex imaginary part
% IMAG(F) is the imaginary part of F.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

gvals = imag(g.vals);
if all(gvals == 0), 
    g.vals = 0; g.n = 1; g.scl.v = 0;
else
    g.vals = vals;
    g = simplify(g);
end