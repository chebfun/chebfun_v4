function C = minus(A,B)
% -  Difference of chebops.
% If A and B are chebops, A-B returns the chebop that represents their
% difference. If one is a scalar, it is interpreted as the scalar times the
% identity operator.

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.

C = plus(A,-B);
end