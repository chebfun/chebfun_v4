function Fout = acsch(F)
% ACSCH(F) is the inverse hyperbolic cosecant of the CHEBFUN F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) acsch(x));