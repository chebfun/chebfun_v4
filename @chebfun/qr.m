function [Q,R] = qr(A,econ)   
% QR	QR factorization
% [Q,R] = QR(A) or QR(A,0), where A is a column quasimatrix with n
% columns, produces a column quasimatrix Q with n orthonormal columns
% and an n x n upper triangular matrix R such that A = Q*R.

% This algorithm was developed by Nick Trefethen, June 2008: see
% Trefethen, "Householder triangularization of a quasimatrix", to appear.
% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

if (nargin>2) | ((nargin==2) & (econ~=0))
    error('chebfun:qr:twoargs',...
          'Use qr(A) or qr(A,0) for QR decomposition of quasimatrix.');
end
if A(1).trans
    error('chebfun:qr:transpose',...
          'QR works only for column quasimatrices.')
end

n = size(A,2); R = zeros(n);

% Set up target quasimatrix E with orthonormal columns: 

[a,b] = domain(A);
E = chebfun(sqrt(0.5),[a b]);
for k = 1:n-1
   x = sin(pi*(-k:2:k)/(2*k))';
   vals = legendre(k,x,'norm'); vals = vals(1,:)';
   E(:,k+1) = chebfun(vals,[a b]);     % kth Legendre poly
end
E = E/sqrt((b-a)/2);                   % normalize for interval length

% Householder triangularization:

V = chebfun;                           % cols of V will store Househ. vectors
for k = 1:n
   I = 1:k-1; J = k+1:n;               % convenient abbreviations
   e = E(:,k);                         % target for this reflection
   x = A(:,k);                         % vector to be mapped to s*e
   normx = norm(x);
   ex = e'*x;
   absex = abs(ex); signex = 1;
   if absex~=0, signex = ex/absex; end
   e = -signex*e; E(:,k) = e;
   y = normx*e;
   v = y - x;                          % vector defining reflection
   if norm(v)==0, v=e; end
   if k>1                              
      v = v - E(:,I)*(E(:,I)'*v);
   end
   v = v/norm(v);
   V(:,k) = v;                         % store this Householder vector
   R(k,k) = normx;
   if k<n
      A(:,J) = A(:,J)-2*v*(v'*A(:,J)); % apply the reflection to A
      r = e'*A(:,J);                   % kth row of R
      R(k,J) = r;
      A(:,J) = A(:,J) - e*r;           % subtract components in direction e
   end
end

% Form the Q quasimatrix from the Householder vectors:

Q = E;
for k = n:-1:1
  v = V(:,k);
  J = k:n;
  w = v'*Q(:,J);
  Q(:,J) = Q(:,J) - 2*v*w;
end
