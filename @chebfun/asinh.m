function Fout = asinh(F)
% ASINH(F) is the inverse hyperbolic sine of the CHEBFUN F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) asinh(x));