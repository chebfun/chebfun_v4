function Fout = cosh(F)
% COSH(F) is the hyperbolic cosine of the CHEBFUN F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) cosh(x));