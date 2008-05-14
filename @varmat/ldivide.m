function C = ldivide(A,B)
% LDIVIDE  Elementwise left divison of varmats, with scalar expansion.

% Toby Driscoll, 14 May 2008.
% Copyright 2008.

C = op_scalar_expand(@ldivide,A,B);

end