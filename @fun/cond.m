function out = cond(f)
% COND	Condition number
% COND(F) is the 2-norm condition number of F.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
s=svd(f,0);
out=s(1)/s(end);
