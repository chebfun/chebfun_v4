function Fout = asin(F)
% ASIN(F) is the arcsine of the CHEBFUN F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) asin(x));