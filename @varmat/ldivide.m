function C = ldivide(A,B)
% .\  Elementwise left divison of varmats, with scalar expansion.

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.

C = op_scalar_expand(@ldivide,A,B);

end