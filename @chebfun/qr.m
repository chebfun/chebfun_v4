function [Q,R] = qr(A,econ)   
% QR	QR factorization.
% [Q,R] = QR(A,0), where A is a column quasimatrix with n columns,
% produces a column quasimatrix Q with n orthonormal columns
% and an n x n upper triangular matrix R such that A = Q*R.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

% The computation is carried out by modified Gram-Schmidt following
% Battles' 2006 PhD thesis.

if (nargin~=2) | ((nargin==2) & (econ~=0))
    error('chebfun:qr:twoargs',...
          'Use qr(A,0) for QR decomposition of quasimatrix.');
end
if A(1).trans
    error('chebfun:qr:transpose',...
          'QR works only for column quasimatrices.')
end
n = size(A,2);
R = zeros(n);
for i = 1:n
    R(i,i) = norm(A(:,i));
    Q(:,i) = A(:,i)/R(i,i);
    for j = i+1:n
        R(i,j) = Q(:,i)'*A(:,j);
        A(:,j) = A(:,j)-R(i,j)*Q(:,i);
    end
end
