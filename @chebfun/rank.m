function r = rank(A,tol)
% RANK	Rank of quasimatrix.
% RANK(A) produces an estimate of the number of linearly independent
% columns or rows of A.
%
% RANK(A,TOL) is the number of singular values of A greater than TOL.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

s = svd(A);
n = min(size(A));
if nargin==1 
   m = 0;
   if A(1).trans
      for i = 1:n
         m = max(m,length(A(i,:)));   
      end
   else
      for i = 1:n
         m = max(m,length(A(:,i)));   
      end
   end
   tol = m*eps(max(s));
end
r = sum(s>tol);
