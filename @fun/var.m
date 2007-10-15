function out = var(f)
% VAR	Variance
% VAR(F) is the variance of the fun F.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
out = mean((f-mean(f)).^2);

