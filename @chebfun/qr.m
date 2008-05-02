function [q,r] = qr(a,econ)
% QR	QR factorization
% [Q,R]=QR(A,0) produces a matrix Q with orthogonal column chebfuns and an upper
% triangular matrix R such that A=Q*R.

if (nargin==2 & econ==0)
    n = numel(a);
    r = zeros(n);
    for i = 1:n
        r(i,i) = norm(a(i));
        q(i) = a(i)/r(i,i);
        for j = i+1:n
            r(i,j) = q(i)'*a(j);
            a(j) = a(j)-r(i,j)*q(i);
        end
    end
else
  error('Use qr(A,0) for economy size decomposition.');
end