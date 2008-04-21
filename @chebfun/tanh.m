function Fout = tanh(F)
% TANH(F) is the hyperbolic tangent of the CHEBFUN F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) tanh(x));