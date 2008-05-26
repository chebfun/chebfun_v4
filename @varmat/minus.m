function C = minus(A,B)
% -  Difference of varmats, with scalar expansion.

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.

C = op_scalar_expand(@minus,A,B);

end
 