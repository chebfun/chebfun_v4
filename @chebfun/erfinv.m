function Fout = erfinv(F)
% ERFINV(F) is the inverse error function for the chebfun F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) erfinv(x));