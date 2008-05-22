function Q = orth(A)
%ORTH   Quasimatrix orthogonalization.
%   Q = ORTH(A) is an orthonormal basis for the range of the
%   column quasimatrix A.
%
%   That is, Q'*Q = I, the columns of Q span the same space as 
%   the columns of A, and the number of columns of Q is the 
%   rank of A.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.


if A(1).trans
   error('ORTH only defined for column quasimatrices')
end

[U,S,V] = svd(A,0);
s = diag(S);
n = min(size(A));
tol = n*eps(max(s));
r = sum(s>tol);
Q = U(:,1:r);
