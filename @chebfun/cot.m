function Fout = cot(F)
% COT(F) is the cotangent of the CHEBFUN F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) cot(x));