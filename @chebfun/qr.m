function [Q,R] = qr(A,econ)   
% QR	QR factorization
% [Q,R] = QR(A) or QR(A,0), where A is a column quasimatrix with n
% columns, produces a column quasimatrix Q with n orthonormal columns
% and an n x n upper triangular matrix R such that A = Q*R.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 
%
% This algorithm was developed by Nick Trefethen, June 2008: see
% Trefethen, "Householder triangularization of a quasimatrix", to appear.

if (nargin>2) || ((nargin==2) && (econ~=0))
    error('CHEBFUN:qr:twoargs',...
          'Use qr(A) or qr(A,0) for QR decomposition of quasimatrix.');
end
if A(1).trans
    error('CHEBFUN:qr:transpose',...
          'QR works only for column quasimatrices.')
end

n = size(A,2); R = zeros(n);

% Set up target quasimatrix E with orthonormal columns: 
[a,b] = domain(A);
for k = 0:n-1
   E(:,k+1) = legpoly(k,[a,b],'norm');
end

% Householder triangularization:

V = chebfun;                           % cols of V will store Househ. vectors
for k = 1:n
   I = 1:k-1; J = k+1:n;               % convenient abbreviations
   e = E(:,k);                         % target for this reflection
   x = A(:,k);                         % vector to be mapped to s*r*e
   ex = e'*x; aex = abs(ex);
   if aex==0, s=1; else s=-ex/aex; end
   e = s*e; E(:,k) = e;                % adjust e by sign factor
   r = norm(x); R(k,k) = r;            % diagonal entry r_kk
   v = r*e - x;                        % vector defining reflection
   if k>1                              
      v = v - E(:,I)*(E(:,I)'*v);      % improve orthogonality
   end
   nv = norm(v);
   if nv==0, v=e; else v=v/nv; end
   V(:,k) = v;                         % store this Householder vector
   if k<n
      A(:,J) = A(:,J)-2*v*(v'*A(:,J)); % apply the reflection to A
      rr = e'*A(:,J); R(k,J) = rr;     % kth row of R
      A(:,J) = A(:,J) - e*rr;          % subtract components in direction e
   end
end

% Form the quasimatrix Q from the Householder vectors:

Q = E;
for k = n:-1:1
  v = V(:,k);
  J = k:n;
  w = v'*Q(:,J);
  Q(:,J) = Q(:,J) - 2*v*w;
end
