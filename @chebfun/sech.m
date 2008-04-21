function Fout = sech(F)
% SECH(F) is the hyperbolic secant of the CHEBFUN F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) sech(x));