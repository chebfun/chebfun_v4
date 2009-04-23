function normA = norm(A,n)
% NORM   Chebfun or quasimatrix norm.
% For quasi-matrices:
%    NORM(A) is the largest singular value of A.
%    NORM(A,2) is the same as NORM(A).
%    NORM(A,1) is the maximum of the 1-norms of the columns of A.
%    NORM(A,inf) is the maximum of the 1-norms of the rows of A.
%    NORM(A,'fro') is the Frobenius norm, sqrt(sum(svd(A).^2)).
%
% For chebfuns:
%    NORM(f) = sqrt(integral of abs(f)^2).
%    NORM(f,2) is the same as NORM(f).
%    NORM(f,'fro') is also the same as NORM(f).
%    NORM(f,1) = integral of abs(f).
%    NORM(f,inf) = max(abs(f)).
%    NORM(f,-inf) = min(abs(f)).
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

if nargin==1, n=2; end                  % 2-norm is the default

if isempty(A), normA = 0;               % empty chebfun has norm 0

elseif min(size(A))==1                  % A is a chebfun 
   switch n
      case 1
         absA = abs(A);
         absA.imps = abs(A.imps);
         normA = sum(absA);
      case {2,'fro'}
         if A.trans 
            normA = sqrt(A*A');
         else
            normA = sqrt(A'*A);
         end
      case {inf,'inf'}
         if isreal(A)
            normA = max(max(A),-min(A));
         else
            normA = max(abs(A));
         end
      case {-inf,'-inf'}
         normA = min(abs(A));
      otherwise
         error('Unknown norm');
   end

elseif min(size(A))>1                  % A is a quasimatrix
   switch n        
      case 1
         normA = max(sum(abs(A),1));
      case 2
         s = svd(A,0);
         normA = s(1);
      case 'fro'
         s = svd(A,0);
         normA = norm(s);
      case {'inf',inf}
         normA = max(sum(abs(A),2));
      otherwise
         error('Unknown norm')
   end
end
normA = real(normA);       % discard possible imaginary rounding errors
