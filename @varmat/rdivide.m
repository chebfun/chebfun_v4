function C = rdivide(A,B)
% RDIVIDE  Elementwise right divison of varmats, with scalar expansion.

% Toby Driscoll, 14 May 2008.
% Copyright 2008.

C = op_scalar_expand(@rdivide,A,B);

end