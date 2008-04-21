function Fout = acsc(F)
% ACSC(F) is the inverse cosecant of the CHEBFUN F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) acsc(x));