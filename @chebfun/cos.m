function Fout = cos(F)
% COS(F) is the cosine of the CHEBFUN F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) cos(x));