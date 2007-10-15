function out = null(A)
% NULL	Null space
% NULL(A) returns the orthonormal basis for the null space of A.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
[u,s,v]=svd(A,0);
out = v(:,find(diag(s)<=eps*norm(A)));

