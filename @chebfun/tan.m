function Fout = tan(F)
% TAN(F) is the tangent of the CHEBFUN F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) tan(x));