function Fout = atan(F)
% ATAN(F) is the arctangent of the CHEBFUN F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) atan(x));