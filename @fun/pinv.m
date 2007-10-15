function out = pinv(A,tol)
% PINV	Pseudoinverse
% X = PINV(A) produces a matrix whose rows are funs so that A*X*A = A and
% X*A*X = X.
%
% X = PINV(A,TOL) uses the tolerance TOL.  The computation uses SVD(A) and any
% singular value less than the tolerance TOL is treated as zero.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
[u,s,v]=svd(A,0);
s=diag(s);
if (nargin==1), tol=max(abs(size(A)))*max(s)*eps; end
r=sum(s>tol);
S=struct('type','()','subs',{{{':'},1:r}});
if (r==0)
  out=0;
else
  out=v(:,1:r)*diag(ones(r,1)./s(1:r))*subsref(u,S)';
end
