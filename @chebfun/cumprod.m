function F = cumprod(F)
% CUMPROD	Indefinite integral of product
% CUMPROD(F) is the indefinite integral of product of F.

% Chebfun Version 2.0
F = exp(cumsum(log(F)));
