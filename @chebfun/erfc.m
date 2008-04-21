function Fout = erfc(F)
% ERFC(F) is the complementary error function for the chebfun F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) erfc(x));