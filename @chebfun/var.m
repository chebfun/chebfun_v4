function out = var(f)
% VAR	Variance
% VAR(F) is the variance of the chebfun F.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
out = mean((f-mean(f)).^2);

