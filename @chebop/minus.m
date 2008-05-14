function C = minus(A,B)
% -  Difference of chebops.
% If A and B are chebops, A-B returns the chebop that represents their
% difference. If one is a scalar, it is interpreted as the scalar times the
% identity operator.

% Toby Driscoll, 14 May 2008.
% Copyright 2008.

C = plus(A,-B);
end