function F = cumprod(f)
% CUMPROD	Indefinite integral of product
% CUMPROD(F) is the indefinite integral of product of F.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
F = exp(cumsum(log(f)));