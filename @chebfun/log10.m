function Fout = log10(F)
% LOG10(F) is the base 10 logarithm of the chebfun F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) log10(x));