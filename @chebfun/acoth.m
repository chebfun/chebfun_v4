function Fout = acoth(F)
% ACOTH(F) is the inverse hyperbolic cotangent of F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) acoth(x));