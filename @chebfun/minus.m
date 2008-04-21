function H = minus(F1,F2)
% -	Minus
% F - G subtracts chebfun G from F or a scalar from a chebfun if either
% F or G is a scalar.

% Chebfun Version 2.0
H = F1+(-F2);
