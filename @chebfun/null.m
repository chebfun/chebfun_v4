function Z = null(A)
% NULL   Null space.
% NULL(A) returns an orthonormal basis for the null space of 
% the column quasimatrix A.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

if A(1).trans
   error('NULL only defined for column quasimatrices')
end

[U,S,V] = svd(A,0);
s = diag(S);
n = min(size(A));
tol = n*eps(max(s));
r = sum(s>tol);
Z = V(:,r+1:n);
