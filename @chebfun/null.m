function out = null(A)
% NULL	Null space
% NULL(A) returns the orthonormal basis for the null space of A.

[u,s,v]=svd(A,0);
out = v(:,find(diag(s)<=eps*norm(A)));