function Fout = sec(F)
% SEC(F) is the secant of the CHEBFUN F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) sec(x));