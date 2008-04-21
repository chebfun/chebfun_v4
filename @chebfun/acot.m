function Fout = acot(F)
% ACOT(F) is the inverse cotangent of F
%

% Chebfun Version 2.0

Fout = comp(F, @(x) acot(x));