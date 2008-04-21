function Fout = asec(F)
% ASEC(F) is the inverse secant of the CHEBFUN F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) asec(x));