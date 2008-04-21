function Fout = acosh(F)
% ACOSH(F) is the inverse hyperbolic cosine of the CHEBFUN F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) acosh(x));