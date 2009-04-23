function C = complex(A,B)
% COMPLEX   Construct complex chebfun from real and imaginary parts.
% C = COMPLEX(A,B) returns the complex result A + Bi, where A and B are
% chebfuns with the same number of columns on the same domain.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

if ~isreal(A) | ~isreal(B)
  error('chebfun:complex:notreal','Inputs must be real.');
end

C = A + 1i*B;
