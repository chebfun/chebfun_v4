function islin = islinear(N)
% ISLINEAR Checks whether a chebop is linear.
% ISLINEAR(N) returns 1 if N is a linear operator, 0 otherwise.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

[ignored ignored islin] = linearise(N,[],1);
