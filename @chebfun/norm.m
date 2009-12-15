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

%   Copyright 2002-2009 by The Chebfun Team. 
%   Last commit: $Author: nich $: $Rev: 489 $:
%   $Date: 2009-06-04 22:25:42 +0100 (Thu, 04 Jun 2009) $:

if nargin==1, n='fro'; end              % Frobenius norm is the default
                                        % (2 norm would be much slower)

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
             mm = minandmax(A);
             normA = max(mm(2),-mm(1));
         else
            normA = sqrt(max(conj(A).*A));
         end
      case {-inf,'-inf'}
         normA = min(abs(A));
      otherwise
         error('CHEBFUN:norm:unknown','Unknown norm');
   end

elseif min(size(A))>1                  % A is a quasimatrix
   switch n        
      case 1
         normA = max(sum(abs(A),1));
      case 2
         s = svd(A,0);
         normA = s(1);
      case 'fro'
         % Find integration dimension: 1 if column, 2 if row
         dim = 1 + double(A(1).trans);  
         normA = sqrt( sum( sum(A.*conj(A),dim) ) );
      case {'inf',inf}
         normA = max(sum(abs(A),2));
      otherwise
         error('CHEBFUN:norm:unknown2','Unknown norm')
   end
end
normA = real(normA);       % discard possible imaginary rounding errors
