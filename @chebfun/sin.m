function Fout = sin(F)
% SIN(F) is the sine of the CHEBFUN F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) sin(x));