function r = rank(A,tol)
% RANK	Rank of quasimatrix.
% RANK(A) produces an estimate of the number of linearly independent
% columns or rows of A.
%
% RANK(A,TOL) is the number of singular values of A greater than TOL.

n = min(size(A));
if (nargin==1) 
    m = 0;
    for i = 1:n;
        m = max(m,length(A(i)));   
    end
    tol = m*norm(A)*eps;  % check this tolerance
end
s = svd(A,0);
r = sum(s>tol);
