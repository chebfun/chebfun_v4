function Fout = asech(F)
% ASECH(F) is the inverse hyperbolic cosecant of the CHEBFUN F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) asech(x));