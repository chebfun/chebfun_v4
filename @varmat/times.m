function C = times(A,B)
% .*  Elementwise multiplication of varmats, with scalar expansion.

% Toby Driscoll, 14 May 2008.
% Copyright 2008.

C = op_scalar_expand(@times,A,B);

end
 