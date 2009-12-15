function Fout = acosh(F)
% ACOSH   Inverse hyperbolic cosine of a chebfun.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

Fout = comp(F, @(x) acosh(x));
Fout.jacobian = anon('@(u) diag(1./sqrt(F.^2-1))*jacobian(F,u)',{'F'},{F});
Fout.ID = newIDnum();