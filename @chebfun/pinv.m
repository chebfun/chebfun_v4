function out = pinv(A,tol)
% PINV	Pseudoinverse
% X = PINV(A) produces a matrix whose rows are chebfuns so that A*X*A = A and
% X*A*X = X.
%
% X = PINV(A,TOL) uses the tolerance TOL.  The computation uses SVD(A) and any
% singular value less than the tolerance TOL is treated as zero.

[u,s,v]=svd(A,0);
s=diag(s);
if (nargin==1), 
    m = 0;
    for i = 1:numel(A);
        m = max(m,length(A(i))); % check this tolerance
    end
    tol=m*max(s)*eps; 
end

r=sum(s>tol);
if (r==0)
  out=0;
else
  out=v(:,1:r)*diag(ones(r,1)./s(1:r))*u(1:r)';
end