function Fout = log2(F)
% LOG2(F) is the base 2 logarithm of the chebfun F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) log2(x));