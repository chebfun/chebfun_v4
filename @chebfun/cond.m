function out = cond(f)
% COND	Condition number
% COND(F) is the 2-norm condition number of F.

s=svd(f,0);
out=s(1)/s(end);