function Fout = erfcx(F)
% ERFCX(F) is the scaled complementary error function for the chebfun F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) erfcx(x));