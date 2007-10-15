function r = rank(A,tol)
% RANK	Rank of matrix whose columns are funs
% RANK(A) produces an estimate of the number of linearly independent
% funs of A.
%
% RANK(A,TOL) is the number of singular values of A greater than TOL.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
if (nargin==1) tol = max(abs(size(A)))*norm(A)*eps; end
s=svd(A,0);
r=sum(s>tol);
