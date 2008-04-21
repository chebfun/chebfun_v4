function Fout = exp(F)
% EXP(F) is the exponential function for the chebfun F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) exp(x));