function h = minus(f,g)
% -	Minus
% F - G subtracts chebfun G from F or a scalar from a chebfun if either
% F or G is a scalar.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
h = f+(-g);