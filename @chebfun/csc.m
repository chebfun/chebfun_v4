function Fout = csc(F)
% CSC(F) is the cosecant of the CHEBFUN F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) csc(x));