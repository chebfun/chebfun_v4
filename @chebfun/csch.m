function Fout = csch(F)
% CSCH(F) is the hyperbolic cosecant of the CHEBFUN F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) csch(x));