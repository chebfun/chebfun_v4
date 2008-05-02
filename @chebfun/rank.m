function r = rank(A,tol)
% RANK	Rank of matrix whose columns are chebfuns
% RANK(A) produces an estimate of the number of linearly independent
% chebfuns of A.
%
% RANK(A,TOL) is the number of singular values of A greater than TOL.

if (nargin==1) 
    m = 0;
    for i = 1:numel(A)
        m = max(m,length(A(i)));   
    end
    tol = m*norm(A)*eps;  % check this tolerance
end
s=svd(A,0);
r=sum(s>tol);
