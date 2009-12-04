function C = minus(A,B)
% -  Difference of linops.
% If A and B are linops, A-B returns the linop that represents their
% difference. If one is a scalar, it is interpreted as the scalar times the
% identity operator.
%
% See www.maths.ox.ac.uk/chebfun.

% Copyright 2008 by Toby Driscoll.
%  Last commit: $Author$: $Rev$:
%  $Date$:


C = plus(A,-B);
end