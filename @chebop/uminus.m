function C = uminus(A)
% -  Negate a chebop.

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.
 
C = chebop( -A.varmat, -A.oparray, A.fundomain, A.difforder );
C.blocksize = A.blocksize;

end