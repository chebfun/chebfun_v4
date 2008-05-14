function C = ctranspose(A)
%CTRANSPOSE Conjugate transpose of a varmat.
  
% Toby Driscoll, 14 May 2008.
% Copyright 2008.

C = varmat( @(n) feval(A,n)' );

end