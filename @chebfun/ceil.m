function g = ceil(f)
% CEIL   Pointwise ceiling of a chebfun.
% G = CEIL(F) returns the chebfun G such that G(X) = CEIL(F(X)) for each
% X in the domain of F.
%
% See also CHEBFUN/FLOOR, CHEBFUN/ROUND, CHEBFUN/FIX, CEIL.

% Copyright 2002-2008 by The Chebfun Team. See www.chebfun.org.

g = -floor(-f);
