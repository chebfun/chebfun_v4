function C = power(A,B)
% .^  Elementwise power of varmats, with scalar expansion.

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.

C = op_scalar_expand(@power,A,B);

end
