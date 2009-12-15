function F = mrdivide(f,g)
% /	Right scalar divide
% F/C divides the fun F by a scalar C.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 
% Last commit: $Author$: $Rev$:
% $Date$:

F=f;
if (isa(g,'double'))
    F.vals=f.vals/g;
    F.scl.v=f.scl.v/abs(g);
else
    error('FUN:mrdivide:funfun','Use ./ to divide a fun into a fun.');
end