function g = imag(g)
% IMAG	Complex imaginary part
% IMAG(F) is the imaginary part of F.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 
% Last commit: $Author$: $Rev$:
% $Date$:

gvals = imag(g.vals);
if all(gvals == 0), 
    g.vals = 0; g.n = 1; g.scl.v = 0;
else
    g.vals = vals;
    g = simplify(g);
end