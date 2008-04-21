function Fout = sqrt(F)
% SQRT  Square root.
% SQRT(F) returns the square root chebfun of a positive or negative chebfun F. 

%  Chebfun Version 2.0

Fout = comp(F, @(x) sqrt(x));