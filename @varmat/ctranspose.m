function C = ctranspose(A)
% CTRANSPOSE  Conjugate transpose of a varmat.
  
% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.

C = varmat( @(n) feval(A,n)' );

end