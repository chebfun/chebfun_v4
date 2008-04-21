function Fout = log(F)
% LOG(F) is the natural logarithm of the chebfun F.
%

% Chebfun Version 2.0

Fout = comp(F, @(x) log(x));