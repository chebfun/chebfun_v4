function Fout = sinh(F)
% SINH(F) is the hyperbolic sine of the CHEBFUN F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) sinh(x));