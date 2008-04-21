function g = ceil(f)
% CEIL Pointwise ceiling function.
%
% G = CEIL(F) returns the chebfun G such that G(X) = CEIL(F(X)) for each
% X in the domain of F.
%
% See also CHEBFUN/FLOOR, CHEBFUN/ROUND, CHEBFUN/FIX, CEIL.

% Chebfun Version 2.0

g = -floor(-f);
