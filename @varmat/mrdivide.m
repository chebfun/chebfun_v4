function C = mrdivide(A,B)
% /  Right matrix division for varmats.

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.

C = varmat( @(n) feval(A,n) / feval(B,n) );

end
  