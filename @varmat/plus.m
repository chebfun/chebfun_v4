function C = plus(A,B)
% +  Sum of varmats, with scalar expansion.

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.

C = op_scalar_expand(@plus,A,B);
end