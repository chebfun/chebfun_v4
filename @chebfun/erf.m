function Fout = erf(F)
% ERF(F) is the error function for the chebfun F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) erf(x));