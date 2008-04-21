function g = round(f)
% ROUND Pointwise rounding function.
%
% G = ROUND(F) returns the chebfun G such that G(X) = ROUND(F(X)) for each
% X in the domain of F.
%
% See also CHEBFUN/FIX, CHEBFUN/FLOOR, CHEBFUN/CEIL, ROUND.

% Chebfun Version 2.0

g = ceil(f-0.5);
