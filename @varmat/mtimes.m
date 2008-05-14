function C = mtimes(A,B)
% *  Multiplication of varmats, with scalar expansion.

% Toby Driscoll, 14 May 2008.
% Copyright 2008.

C = op_scalar_expand(@mtimes,A,B);

end
  