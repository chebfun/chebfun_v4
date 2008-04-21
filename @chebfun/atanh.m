function Fout = atanh(F)
% ATANH(F) is the hyperbolic arctangent of the CHEBFUN F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) atanh(x));