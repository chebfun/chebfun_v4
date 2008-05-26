function C = mldivide(A,B)
% \  Left matrix division for varmats.

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.

C = varmat( @(n) feval(A,n) \ feval(B,n) );

end
  