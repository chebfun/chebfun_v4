function C = times(A,B)
% .*  Elementwise multiplication of varmats, with scalar expansion.

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.

C = op_scalar_expand(@times,A,B);

end
 