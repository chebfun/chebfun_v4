function C = complex(A,B)
% COMPLEX   Construct complex chebfun from real and imaginary parts.
% C = COMPLEX(A,B) returns the complex result A + Bi, where A and B are
% chebfuns with the same number of columns on the same domain.

% Copyright 2002-2009 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

if ~isreal(A) | ~isreal(B)
  error('chebfun:complex:notreal','Inputs must be real.');
end

C = A + 1i*B;
