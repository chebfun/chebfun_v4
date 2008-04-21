function Fout = acos(F)
% ACOS(F) is the arccosine of the CHEBFUN F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) acos(x));