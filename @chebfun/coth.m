function Fout = coth(F)
% COTH(F) is the hyperbolic cotangent of the CHEBFUN F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) coth(x));